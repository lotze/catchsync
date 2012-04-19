#!/usr/bin/ruby

require 'rubygems'
require 'catch'
require 'json'
require 'time'

config_file = File.join(File.dirname(__FILE__),"config.json")
config = JSON.parse(IO.read(config_file))

local_directory = config['local_directory'] || "./notes"
if !File.directory?(local_directory)
  begin
    require 'fileutils'
    Dir.mkpath(File.dirname(local_directory))
  rescue Exception => e
    # no fileutils; that's okay, you just need to create the directory yourself
  end
  system("git clone #{config['git_repository']} #{local_directory}")
end

synced_at = Time.at(0)
sync_file = File.join(local_directory, "synced.at")
if File.exists?(sync_file)
  synced_at = Time.at(IO.read(sync_file).to_i)
end

new_sync = Time.new

any_changes = false
  
still_in_catch_set = Set.new

catch_connection = Catch::Client.new(:username => config['catch_username'], :password => config['catch_password'])

catch_connection.notes.each do |note_data|
  note_id = note_data.id
  still_in_catch_set.add(note_id)
  modified_at = Time.parse(note_data.server_modified_at)
  puts "checking catch note #{note_id}"
  if modified_at > synced_at
    any_changes=true
    puts "   changed! (at #{modified_at})"
    note = catch_connection.note(note_id)
    File.open(File.join(local_directory,"#{note_id}.txt"), "w") do |f|
      f.puts note.text
    end
    Dir.chdir(local_directory) do
      system("git add #{note_id}.txt")
    end
  end
end

File.open(sync_file, "w") do |f|
  f.puts new_sync.to_i
end

Dir.chdir(local_directory) do
  system("git add synced.at")
  
  existing_files = Dir.glob("*.txt")
  existing_files.each do |file|
    note_id = File.basename(file).gsub(/\.txt$/,'')
    if !still_in_catch_set.include?(note_id)
      any_changes = true
      system("git rm #{note_id}.txt")
    end
  end
  
  if any_changes
    system("git commit -m 'synced up to #{new_sync} (#{new_sync.to_i})' && git push -q -u origin master")
  end
end

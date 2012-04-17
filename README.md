# What is This?

It's a simple ruby script to sync your text notes from catch.com's wonderful service and store them in a git repository.  I use it for backing up my notes and being able to use git to see changes (for example, I can see how my TODO list has changed over time).

Thanks to Sam Mullen for creating the catch ruby gem!  (https://github.com/samullen/catch)

Note that this does not sync changes from the git repository to catch -- it treats catch as the authentic source and updates the git repository it also assumes that there are no other changes being made to the git repository).  The git repository is just there as a version control repository for your catch notes, which are the 'authentic' source.

It also doesn't sync comments on notes or multimedia notes.  If you want to add these features, you are welcome to fork this project and submit a pull request.  :)  I mainly use catch for text notes, so I don't need more functionality yet.

## Installation

```
git clone https://github.com/lotze/catchsync
gem install json
gem install catch
gem install fileutils
cp sample_config.json config.json
```

edit config.json to add your git repository, catch username, and catch password

### Local git repository

You can easily use a local git repository by doing the following

```
mkdir /catch_repo
cd /catch_repo
git init --bare
```

and setting the git_repository value in config.json to /catch_repo

(yes, you should probably put it somewhere other than in the root directory)

## Use

```
ruby catch_sync.rb
```

## Note on Patches/Pull Requests

* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but
   bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

## Copyright

This work by Thomas Lotze is licensed under a Creative Commons Attribution 3.0 Unported License (http://creativecommons.org/licenses/by/3.0/)
You are wecome to use it, but please attribute http://thomaslotze.com and/or https://github.com/lotze/catchsync.
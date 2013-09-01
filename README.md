Capistrano::Rsync for Capistrano v3
===================================
[![Gem version](https://badge.fury.io/rb/capistrano-rsync.png)](http://badge.fury.io/rb/capistrano-rsync)

Deploy with Rsync to your server from any local (or remote) repository.  
Saves you from having to install Git on your production machine and allows you to customize which files you want to deploy.

Works with the new [**Capistrano v3**](http://www.capistranorb.com/) and is suitable for deploying any apps, be it Ruby or Node.js.  
Currently works **only with Git** (as does Capistrano v3), so please shout out your interest in other SCMs.


Using
-----
Install with:
```
gem install capistrano-rsync
```

Require it at the top of your `Capfile`:
```ruby
require "capistrano/setup"
require "capistrano/deploy"
require "capistrano/rsync"
```

Set some `rsync_options` to your liking:
```ruby
set :rsync_options, %w[--recursive --delete --delete-excluded --exclude .git*]
```

And after setting regular Capistrano options, deploy as usual!
```
cap deploy
```

### How does it work?
Capistrano::Rsync clones your repository to `tmp/cache` on your local machine, checks out the branch set in the `branch` variable (`master` by default) and then Rsyncs that directory to your servers.

### Excluding files from being deployed
If you don't want to deploy everything you've committed to your repository, pass some `--exclude` options to Rsync:
```ruby
set :rsync_options, %w[
  --recursive --delete --delete-excluded
  --exclude .git*
  --exclude /config/database.yml
  --exclude /test/***
]
```


Variables
---------
Set Capistrano variables with `set name, value`.

#### branch
The Git branch to checkout.  
Defaults to `master`.

#### repo_url
The path or URL to a Git repository to clone from.  
Defaults to `.`.

#### rsync_stage 
Location where to clone your repository for staging, checkouting and rsyncing.  
Defaults to `tmp/cache`.

#### rsync_options
Array of options to pass to `rsync`.  
Defaults to `[]`.


License
-------
Capistrano::Rsync is released under a *Lesser GNU Affero General Public License*, which in summary means:

- You **can** use this program for **no cost**.
- You **can** use this program for **both personal and commercial reasons**.
- You **do not have to share your own program's code** which uses this program.
- You **have to share modifications** (e.g bug-fixes) you've made to this program.

For more convoluted language, see the `LICENSE` file.


About
-----
**[Andri Möll](http://themoll.com)** made this happen.  
[Monday Calendar](https://mondayapp.com) was the reason I needed this.

If you find Capistrano::Rsync needs improving, please don't hesitate to type to me now at [andri@dot.ee](mailto:andri@dot.ee) or [create an issue online](https://github.com/moll/capistrano-rsync/issues).

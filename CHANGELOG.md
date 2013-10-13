## 1.0.2 (Oct 13, 2013)
- Updates README and code comments.

## 1.0.1 (Sep 2, 2013)
- Updates README and adds implementation details to it.

## 1.0.0 (Sep 2, 2013)
- Makes the `rsync:stage` task public for extending and hooking.
- Renames `rsync:create_release` to `rsync:release`. Old name still works.
- Adds optional caching to `rsync_cache` directory on the server.

## 0.2.1 (Sep 1, 2013)
- Fixes starting with no previous local repository cache.  
  Note to self: Avoid writing code without integration tests.

## 0.2.0 (Sep 1, 2013)
- Passes user given in `role :app, "user@host"` to `rsync` if set.

## 0.1.338 (Sep 1, 2013)
- Adds gem dependency on Capistrano v3.

## 0.1.337 (Sep 1, 2013)
- First release. Let's get syncing!

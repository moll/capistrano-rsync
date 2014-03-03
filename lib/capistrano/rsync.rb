require File.expand_path("../rsync/version", __FILE__)

# NOTE: Please don't depend on tasks without a description (`desc`) as they
# might change between minor or patch version releases. They make up the
# private API and internals of Capistrano::Rsync. If you think something should
# be public for extending and hooking, please let me know!

rsync_cache = lambda do
  cache = fetch(:rsync_cache)
  cache = deploy_to + "/" + cache if cache && cache !~ /^\//
  cache
end

# Use cap3's load:defaults to set default vars so that they can be overridden.
namespace :load do
  task :defaults do
    set :rsync_options, []
    set :rsync_copy, "rsync --archive --acls --xattrs"

    # Stage is used on your local machine for rsyncing from.
    set :rsync_stage, "tmp/deploy"

    # Cache is used on the server to copy files to from to the release directory.
    # Saves you rsyncing your whole app folder each time.  If you nil rsync_cache,
    # Capistrano::Rsync will sync straight to the release path.
    set :rsync_cache, "shared/deploy"
  end
end

Rake::Task["deploy:check"].enhance ["rsync:hook_scm"]
Rake::Task["deploy:updating"].enhance ["rsync:hook_scm"]

desc "Stage and rsync to the server (or its cache)."
task :rsync => %w[rsync:stage] do
  on roles(:all), in: :parallel do |host|
    user = host.user + "@" if !host.user.nil?

    run_locally do
      rsynccmd = []
      rsynccmd.concat(fetch(:rsync_options))
      rsynccmd << fetch(:rsync_stage) + "/"
      rsynccmd << "#{user}#{host.hostname}:#{rsync_cache.call || release_path}"
      execute :rsync, *rsynccmd
    end

  end
end

namespace :rsync do
  task :hook_scm do
    Rake::Task.define_task("#{scm}:check") do
      invoke "rsync:check" 
    end

    Rake::Task.define_task("#{scm}:create_release") do
      invoke "rsync:release" 
    end
  end

  task :check do
    # Everything's a-okay inherently!
  end

  task :create_stage do
    next if File.directory?(fetch(:rsync_stage))

    run_locally do
      execute :git, "clone #{fetch(:repo_url, '.')} #{fetch(:rsync_stage)}";
    end
  end

  desc "Stage the repository in a local directory."
  task :stage => %w[create_stage] do
    run_locally do
      within fetch(:rsync_stage) do
        execute :git, "fetch --quiet --all --prune"
        execute :git, "reset --hard origin/#{fetch(:branch)}"
      end
    end
  end

  desc "Copy the code to the releases directory."
  task :release => %w[rsync] do
    # Skip copying if we've already synced straight to the release directory.
    next if !fetch(:rsync_cache)

    copy = %(#{fetch(:rsync_copy)} "#{rsync_cache.call}/" "#{release_path}/")
    on roles(:all).each do execute copy end
  end

  # Matches the naming scheme of git tasks.
  # Plus was part of the public API in Capistrano::Rsync <= v0.2.1.
  task :create_release => %w[release]
end

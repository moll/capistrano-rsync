require 'capistrano/scm/plugin'

class Capistrano::Rsync < Capistrano::SCM::Plugin
  def set_defaults
    set_if_empty :rsync_options, %w[
      --archive  --compress
      --delete --delete-excluded
      --exclude log/capistrano.log
      --exclude log/
      --include log/*
      --exclude Capfile
    ]
    set_if_empty :rsync_extra_options, []
  end

  def register_hooks
    after "deploy:new_release_path", "rsync:create_release"
    before "deploy:set_current_revision", "rsync:set_current_revision"
  end

  def define_tasks
    namespace :rsync do
      task :sync do
        on release_roles :all do |role|
          run_locally do
            execute :rsync,
              *fetch(:rsync_options),
              *(ARGV.include?('--verbose') ? ['--verbose'] : []),
              *fetch(:rsync_extra_options),
              './', "#{role.user&.concat('@')}#{role.hostname}:#{repo_path}/"
          end
        end
      end

      task create_release: :sync do
        on release_roles :all do
          execute :cp, '-r', repo_path, release_path
        end
      end

      task :set_current_revision do
        set :current_revision, now
      end
    end
  end
end

require_relative 'rsync/version'

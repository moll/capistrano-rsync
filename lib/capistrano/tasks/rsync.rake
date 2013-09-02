Rake::Task["deploy:check"].enhance ["rsync:hook_scm"]
Rake::Task["deploy:updating"].enhance ["rsync:hook_scm"]

# NOTE: Please don't depend on tasks without a description (`desc`) remaining
# as they are between minor or patch version releases. They make up the private
# API and internalas of Capistrano::Rsync. If you think something should be
# public for extending, please let me know!

namespace :rsync do
  task :hook_scm do
    Rake::Task.define_task("#{scm}:check") do
      invoke "rsync:check" 
    end

    Rake::Task.define_task("#{scm}:create_release") do
      invoke "rsync:create_release" 
    end
  end

  task :check do
    # Everything's a-okay inherently!
  end

  task :create_stage do
    next if File.directory?(fetch(:rsync_stage))

    clone = %W[git clone]
    clone << fetch(:repo_url, ".")
    clone << fetch(:rsync_stage)
    Kernel.system *clone
  end

  desc "Stage the repository in a local directory."
  task :stage => %w[create_stage] do
    Dir.chdir fetch(:rsync_stage) do
      update = %W[git fetch --quiet --all --prune]
      Kernel.system *update

      checkout = %W[git reset --hard origin/#{fetch(:branch)}]
      Kernel.system *checkout
    end
  end

  desc "Copy the staged repository to the releases directory."
  task :create_release => %w[stage] do
    roles(:all).each do |role|
      user = role.user + "@" if !role.user.nil?

      rsync = %w[rsync]
      rsync.concat fetch(:rsync_options)
      rsync << fetch(:rsync_stage) + "/"
      rsync << "#{user}#{role.hostname}:#{release_path}"

      Kernel.system *rsync
    end
  end
end

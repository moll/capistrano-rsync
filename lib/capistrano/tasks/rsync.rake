Rake::Task["deploy:check"].enhance ["rsync:hook_scm"]
Rake::Task["deploy:updating"].enhance ["rsync:hook_scm"]

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

    clone = %W[git clone --mirror]
    clone << fetch(:repo_url, ".")
    clone << fetch(:rsync_stage)
    Kernel.system *clone
  end

  task :update_stage => %w[create_stage] do
    Dir.chdir fetch(:rsync_stage) do
      update = %W[git remote update]
      Kernel.system *update

      checkout = %W[git reset --hard #{fetch(:branch)}]
      Kernel.system *checkout
    end
  end

  desc "Copy the repository to the releases directory."
  task :create_release => %w[update_stage] do
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

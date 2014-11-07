module Capistrano
  module Rsync
    module Scm

      class Git < Capistrano::Rsync::Scm::Base
        attr_reader :context

        def get_current_revision_cmd
          %W[git rev-parse HEAD]
        end

        def create_stage_cmds
          cmd = []
          clone = %W[git clone]
          clone << context.fetch(:repo_url, ".")
          clone << context.fetch(:rsync_stage)
          cmd << clone
          cmd
        end

        def update_stage_cmds
          cmd = []
          update = %W[git fetch --quiet --all --prune]
          cmd << update
          checkout = %W[git reset --hard origin/#{fetch(:branch)}]
          cmd << checkout
          cmd
        end
      end

    end
  end
end

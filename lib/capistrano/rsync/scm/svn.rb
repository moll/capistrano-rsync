module Capistrano
  module Rsync
    module Scm

      class Svn < Capistrano::Rsync::Scm::Base
        attr_reader :context

        def get_current_revision_cmd
          "svn info | grep '^Revision:' | sed -e 's/^Revision: //'"
        end

        def create_stage_cmds
          cmd = []

          clone = %W[svn checkout]
          clone << context.fetch(:repo_url, ".")
          clone << context.fetch(:rsync_stage)

          clone << %W[--username #{context.fetch(:rsync_scm_username)}] if context.fetch(:rsync_scm_username)
          clone << %W[--password #{context.fetch(:rsync_scm_password)}] if context.fetch(:rsync_scm_password)

          cmd << clone.flatten

          cmd
        end

        def update_stage_cmds
          cmd = []

          update = %W[svn update]
          update << %W[--username #{context.fetch(:rsync_scm_username)}] if context.fetch(:rsync_scm_username)
          update << %W[--password #{context.fetch(:rsync_scm_password)}] if context.fetch(:rsync_scm_password)

          cmd << update.flatten

          checkout = %W[svn revert --recursive .]
          cmd << checkout

          cmd
        end
      end

    end
  end
end

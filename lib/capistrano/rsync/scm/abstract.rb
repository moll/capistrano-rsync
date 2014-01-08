module Capistrano
  module Rsync
    module Scm

      # Abstract class to be inherited with the abstract methods to be implemented.
      # Provides the capistrano context.
      class Base
        attr_reader :context

        def initialize(context)
          @context = context
        end

        # Returns array of commands required to create the stage respository.
        # Skipped if rsync_stage directory already exists.
        def create_stage_cmds
          throw NotImplementedError
        end

        # Returns array of commands required to update the stage repository
        # and prepare it to be ready to be rsynced to rsync_cache.
        #
        # Commands will be executed in the rsync_stage directory.
        def update_stage_cmds
          throw NotImplementedError
        end
      end

    end
  end
end


require File.expand_path("../rsync/version", __FILE__)
load File.expand_path("../tasks/rsync.rake", __FILE__)

set :rsync_stage, "tmp/deploy"
set :rsync_options, []

module Capistrano
  module Rsync
  end
end

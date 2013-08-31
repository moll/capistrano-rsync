require File.expand_path("../lib/capistrano/rsync/version", __FILE__)

Gem::Specification.new do |gem|
  gem.name = "capistrano-rsync"
  gem.version = Capistrano::Rsync::VERSION

  gem.author = "Andri Möll"
  gem.email = "andri@dot.ee"
  gem.license = "LAGPL"

  gem.files = `git ls-files`.split($/)
  gem.executables = gem.files.grep(/^bin\//).map(&File.method(:basename))
  gem.test_files = gem.files.grep(/^spec\//)
  gem.require_paths = ["lib"]
end

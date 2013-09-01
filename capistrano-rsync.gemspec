require File.expand_path("../lib/capistrano/rsync/version", __FILE__)

Gem::Specification.new do |gem|
  gem.name = "capistrano-rsync"
  gem.version = Capistrano::Rsync::VERSION
  gem.homepage = "https://github.com/moll/capistrano-rsync"
  gem.summary = <<-end.strip.gsub(/\s*\n\s*/, " ")
    Deploy with Rsync from any local (or remote) repository.
    Capistrano v3 ready!
  end

  gem.description = <<-end.strip.gsub(/\s*?\n(\n?)\s*/, " \\1\\1")
    Deploy with Rsync to your server from any local (or remote) repository.

    Saves you the need to install Git on your production machine and deploy all
    of your development files each time!

    Works with the new Capistrano v3!
    Suitable for deploying any apps, be it Ruby or Node.js.
  end

  gem.author = "Andri Möll"
  gem.email = "andri@dot.ee"
  gem.license = "LAGPL"

  gem.files = `git ls-files`.split($/)
  gem.executables = gem.files.grep(/^bin\//).map(&File.method(:basename))
  gem.test_files = gem.files.grep(/^spec\//)
  gem.require_paths = ["lib"]

  gem.add_dependency "capistrano", ">= 3.0.0.pre14", "< 4"
end

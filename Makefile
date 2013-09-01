NAME = capistrano-rsync

love:
	@echo "Feel like makin' love."

pack:
	gem build $(NAME).gemspec

publish:
	gem push $(NAME)-*.gem
	
.PHONY: love pack publish

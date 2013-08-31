NAME = capistrano-rsync

love:
	@echo "Feel like makin' love."

pack:
	gem build $(NAME).gemspec

publish:
	gem publish $(NAME)-*.gem
	
.PHONY: love pack publish

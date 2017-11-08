GIT_REVISION = "git: #{`git log --pretty=format:'%h - %ai' -n 1`}, who: #{`whoami`}, dir: #{`pwd`}".freeze

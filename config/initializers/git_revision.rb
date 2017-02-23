GIT_REVISION = `git --git-dir=/home/ubuntu/brainpad log --pretty=format:'%h - %ai' -n 1`
WHOAMI = "who: #{`whoami`}, dir: #{`pwd`}"

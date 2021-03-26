#!/bin/false

# shellcheck shell=sh

# Partially based on instructions from:
# ci/run-docker.sh
#
# Note: Alpine (and consequently the other variant ["non-32-bit"]) complains of:
# git-compat-util.h:  1139:	#error "Git requires REG_STARTEND support. Compile with NO_REGEX=NeedsStartEnd"
# and no
# ```bash
# export NO_REGEX=NeedsStartEnd
# /usr/src/git/ci/run-docker-build.sh 0
# ```
# helps

docker run -itv "${PWD}:/usr/src/git" --entrypoint /bin/bash "daald/ubuntu32:xenial"

# And then, inside, initialize with:

export jobname=Linux32

# Helpful initializations:

cat >> ~/.gdbinit <<"EOF"
# https://stackoverflow.com/a/3176802/2309247
set history save on
set history size -1
set history filename ~/.gdb_history
EOF
chmod 600 ~/.gdbinit

# cd to repo

cd /usr/src/git/ || echo "cd error!"

# In lieu of `$ make`:
ci/run-docker-build.sh 0

# # And then run a test with:
# prove t/t6130-pathspec-noglob.sh
# t/t6130-pathspec-noglob.sh
# ci/run-docker-build.sh 0 && prove t/t6130-pathspec-noglob.sh

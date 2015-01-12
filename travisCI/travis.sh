#!/bin/bash
# Credits: http://stackoverflow.com/a/26082445/756986
set -e

export PING_SLEEP=60s
export WORKDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
export BUILD_OUTPUT=$WORKDIR/build.out

touch $BUILD_OUTPUT

dump_output() {
   echo "############# Dependency build log(tail -1000) start #############"
   tail -1000 $BUILD_OUTPUT
   echo "############# Dependency build log end #############"
}
error_handler() {
  echo ERROR: An error was encountered with the build.
  dump_output
  exit 1
}
# If an error occurs, run our error handler to output a tail of the build
trap 'error_handler' ERR

# Set up a repeating loop to send some output to Travis.

bash -c "while true; do echo \$(date) - building ...; sleep $PING_SLEEP; done" &
PING_LOOP_PID=$!

export changed_files=`git diff-tree --no-commit-id --name-only -r $TRAVIS_COMMIT`
echo $changed_files
# Exit if nothing to check
if [ -z "$changed_files" ]
then
    echo "Nothing to test"
    kill $PING_LOOP_PID
    exit 0
fi

# Check individual files ending in ".rb"
for file in $changed_files 
do
    if [[ ${file: -3} == ".rb" ]]
    then
        # Dump output of building dependencies to log file
        brew reinstall $(brew deps $file) >> $BUILD_OUTPUT 2>&1
        # Explicitly print the verbose output of test-bot
        brew test-bot $file -v
    fi
done


# The build was successful dump the output
dump_output

# nicely terminate the ping output loop
kill $PING_LOOP_PID

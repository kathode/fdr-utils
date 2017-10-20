#!/bin/bash
  
# Expects a .csp file in the first argument,
# and a .json file as second argument. Diagnostics
# are printed on stderr when --format is some other
# than 'colour' or 'plain'.

# If using OSX, otherwise define it to the default
if [ -e /Applications/FDR4.app/Contents/MacOS/refines ]
then
  REFINES=/Applications/FDR4.app/Contents/MacOS/refines
else
  REFINES=refines
fi

# The following 'awk' program filters the stderr output of FDR
# so that it can be conveniently monitored on a terminal, like 'tmux'
# where we add a carriage-return to lines with the same first work,
# such as in the case of "Constructed X states and Y transitions".

# It also displays a timer for convenience!

# By default it redirects the 'json' output to the second argument.
# This is necessary, because the output with format 'colour' or 'plain'
# does not redirect debug information to 'stderr', and 'json' is a 
# convenient output format.

echo "Running FDR on file '$1', outputing json into '$2' and diagnostings into 'stderr' via awk"

$REFINES --format json $1 2>&1 >$2 | awk 'BEGIN { prev = ""; start = systime();
                          while (getline) {
                                if ($1 != prev) { printf("%s : %s",strftime("%H:%M:%S",systime()-start), $0); }
                                else { printf("%s : %s\r",strftime("%H:%M:%S",systime()-start),$0); }
                                prev = $1
                        } }'

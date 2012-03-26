#!/bin/sh

# run matlab in text mode
exec /afs/engr.wisc.edu/apps/bin/matlab  -nojvm -nodisplay -nosplash -r "$*"

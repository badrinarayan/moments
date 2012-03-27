#!/bin/sh

# run matlab in text mode
exec /opt/cae/bin/matlab -nojvm -nodisplay -nosplash -r "$*; exit"

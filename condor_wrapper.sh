#!/bin/sh

# run matlab in text mode
exec /cae/apps/bin/matlab -nojvm -nodisplay -nosplash -r "$*; exit"

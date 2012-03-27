#!/bin/sh

# run matlab in text mode
exec /progs/MATLAB/R2011b/bin/matlab -nojvm -nodisplay -nosplash -r "$*; exit"

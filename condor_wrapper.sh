#!/bin/sh

# run matlab in text mode
exec /progs/MATLAB/R2011b/bin/matlab -nodesktop -nojvm -nodisplay -nosplash -r "$*"

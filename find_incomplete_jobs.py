#!/usr/bin/env python
# Check output directory for completeness
# Run like this:
# ./find_incomplete_jobs.py experiment
import glob, sys, re, os
experiment = sys.argv[1]
print experiment
all_expts = set(range(1,481))
completed = set(int(re.search(r'(\d+)',os.path.basename(x)).group(0)) for x in glob.glob("outputs/%s/output*mat" % experiment))
remaining = all_expts - completed
print remaining


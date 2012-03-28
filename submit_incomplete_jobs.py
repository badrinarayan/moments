#!/usr/bin/env python
# Check output directory for completeness
# Run like this:
# ./find_incomplete_jobs.py experiment
import glob, sys, re, os
experiment = sys.argv[1]
files = set(os.path.basename(x) for x in glob.glob("outputs/%s/output*mat" % experiment))
for l in open("%s.submit" % experiment).readlines()[:-1]:
	if not l.startswith("fileNo"):
		print l.strip()
for i in range(1,481):
	if ("output%d.mat" % i) not in files:
		print ("fileNo = %d" % i)
		print "Queue"

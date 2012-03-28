#!/usr/bin/env python
# Produces condor files for incomplete jobs
# Run like this:
# ./submit_incomplete_jobs.py experiment
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

#!/usr/bin/env python

# Edited to remove requirement for unnecessary dependencies- from file vcftagprimersite.py 
# (https://github.com/artic-network/fieldbioinformatics/blob/master/artic/vcftagprimersites.py)

import csv
from collections import defaultdict

def read_bed_file(fn):
	bedfile = []
	with open(fn) as csvfile:
		reader = csv.reader(csvfile, dialect='excel-tab')
		for row in reader:
			bedrow = {}
			bedrow['Primer_ID'] = row[3]
			
			if len(row) >= 6:
				# new style bed
				bedrow['direction'] = row[5]
			elif len(row) == 5:
				# old style without directory
				if 'LEFT' in row[3]:
					bedrow['direction'] = '+'
				elif 'RIGHT' in row[3]:
					bedrow['direction'] = '-'
				else:
					print("Malformed BED file!", file=sys.stderr) 
					raise SystemExit

			if bedrow['direction'] == '+':
				bedrow['end'] = int(row[2])
				bedrow['start'] = int(row[1])
			else:
				bedrow['end'] = int(row[1])
				bedrow['start'] = int(row[2])
			bedfile.append(bedrow)
	return bedfile

if __name__ == "__main__":
    bedfile = read_bed_file(sys.argv[1])
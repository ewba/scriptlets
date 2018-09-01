#!/usr/bin/env python3

import csv
import requests

# NOTE: modify these three!
inFile = 'missing_trashpoints.csv'
authKey = ''
dictFS = '_' # csv file header subfield delimiter for eg. areas (areas_0, areas_1)

url = 'https://api.app.worldcleanupday.com/api/v1/trashpoints'
headers = { "Authorization": "Bearer " + authKey }

def sendTP(tp):
	gid = tp['id']
	del tp['id']
	payload = tp

	r = requests.put(url, json=payload, headers=headers)
	print(r.status_code, gid)
	if r.status_code != 200:
		print(r.text)
		print()
		print(payload)

with open(inFile, newline='') as csvFile:
	reader = csv.DictReader(csvFile)
	for row in reader:
		if row['location_latitude'] == '':
			# partial row, no data
			continue

		tp = {}
		# users and timestamps get overwritten, but let's be thorough, since they're marked as required
		for cat in 'id', 'datasetId', 'address', 'status', 'name', 'amount', 'createdAt', 'createdBy', 'updatedAt', 'updatedBy', 'team':
			tp[cat] = row[cat]

		tp['location'] = { 'latitude': float(row['location_latitude']), 'longitude': float(row['location_longitude']) }

		# collate the split dicts
		for dic in 'origin', 'composition', 'areas', 'hashtags':
			tp[dic] = []
			for n in range(50): # overshoot in case it grows
				key = dic + dictFS + str(n)
				if key in row and row[key] != '':
					tp[dic].append(row[key])
				else:
					break

		# old tps may not have origin set, but it is mandatory
		# use a default
		if len(tp['origin']) == 0:
			tp['origin'] = ["household"]

		# leave a signature for any future analyses
		tp['hashtags'].append("#RestoreBot")

		# save it on the server
		sendTP(tp)

########################
# In case the restorees are interspersed in a bigger csv:
#   copy id column of missing points to $missing then run this to filter out the rest of the data:
# head -n1 missing_trashpoints_search.csv > missing_trashpoints_search.alone.csv
# { echo "$missing"; sed 's,^",,' missing_trashpoints_search.csv; } | sort | uniq -D -w36 | sed 's,^,",; s,[^"]$,&",' >> missing_trashpoints_search.alone.csv

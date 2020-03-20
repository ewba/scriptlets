#!/bin/bash
# create a csv dump of nominatim geolocated cities
# ONLY USE FOR SMALL LISTS!
data=geolocation-inputs
results=geolocation-results.csv
baseurl="https://nominatim.openstreetmap.org/search?countrycodes=si&limit=1&format=json&city="
echo "name;lat;lon" > "$results"

while read dest; do
  curl -sS "$baseurl$dest" |
    sed -r 's/^.*"lat":"([0-9.]+)","lon":"([0-9.]+)","display_name":"([^"]+)".*/\3;\1;\2\n/'
  sleep 5
done < "$data" | sort >> "$results"

grep -qF "[]" "$results" && echo "Some lookups failed, check the input data!"

wc -l "$data" "$results"
echo "The results should have one line more than the input due to the csv header."

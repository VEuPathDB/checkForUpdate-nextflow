#!/usr/bin/env bash

set -euo pipefail

checkForUpdate.pl --method $method \
		  --id $id \
		  --buildAbbrev $buildAbbrev \
		  --project $project \
		  --storageDir storage \
		  --outputFile needsUpdate.txt \
		  --ebiFtpUser $ebiFtpUser \
		  --ebiFtpPassword $ebiFtpPassword

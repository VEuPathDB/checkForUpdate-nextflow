#!/usr/bin/env bash

set -euo pipefail

checkForUpdate.pl --method $method --id $id --project $project --buildSubDir $buildSubDir --abbrev $abbrev --ebiFtpUser $ebiFtpUser --ebiFtpPassword $ebiFtpPassword --storageDir storage --outputFile needsUpdate.txt

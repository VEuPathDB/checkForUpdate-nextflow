#!/usr/bin/perl

use strict;
use warnings;
use Getopt::Long;

my ($method, $id, $buildAbbrev, $project, $storageDir, $outputFile, $ebiFtpUser, $ebiFtpPassword);

&GetOptions("method=s"=> \$method,
	    "id=s"=> \$id,
	    "buildAbbrev=s"=> \$buildAbbrev,
	    "project=s"=> \$project,
            "storageDir=s"=> \$storageDir,
            "outputFile=s"=> \$outputFile,
            "ebiFtpUser=s"=> \$ebiFtpUser,
            "ebiFtpPassword=s"=> \$ebiFtpPassword);

open(OUT,">$outputFile");

if ($method =~  /^Uniprot/) { 
    `wget "https://rest.uniprot.org/uniprotkb/stream?compressed=true&format=fasta&query=proteome%3A${id}" --tries=5 --output-document ./$buildAbbrev.fasta.gz`;
    `gunzip $buildAbbrev.fasta.gz`;
    `grep ">" $buildAbbrev.fasta > newHeaders.txt`;
    `sort newHeaders.txt -o sortedHeaders.txt`;
	
    if (-e "/storage/$buildAbbrev.txt") {
        my $needsUpdate = `diff /storage/$buildAbbrev.txt ./sortedHeaders.txt -q`;

	if (length($needsUpdate) != 0) {
	    `cp sortedHeaders.txt /storage/$buildAbbrev.txt`;
	    print OUT "$buildAbbrev\n";
        }

    }

    else {
        `cp sortedHeaders.txt /storage/$buildAbbrev.txt`;
        print OUT "$buildAbbrev\n";
    }
}

elsif ($method =~  /^Ebi/) {
    `wget --ftp-user ${ebiFtpUser} --ftp-password ${ebiFtpPassword} -O ${id}.sql.gz ftp://ftp-private.ebi.ac.uk:/EBIout/${buildAbbrev}/coredb/${project}/${id}.sql.gz`;

    if (-e "/storage/$id.sql.gz") {
        my $needsUpdate = `diff /storage/$id.sql.gz ./$id.sql.gz -q`;

        if (length($needsUpdate) != 0) {
            `cp ${id}.sql.gz /storage/${id}.sql.gz`;
            print OUT "$id\n";
        }
    }

    else {
        `cp ${id}.sql.gz /storage/${id}.sql.gz`;
        print OUT "$id\n";
    }
}

else {
    die "Line needs to start with Uniprot or Ebi\n";
}

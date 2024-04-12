#!/usr/bin/perl

use strict;
use warnings;
use Getopt::Long;

my ($method,$id,$project,$buildSubDir,$abbrev,$ebiFtpUser,$ebiFtpPassword,$storageDir,$outputFile);

&GetOptions("method=s"=> \$method,
	    "id=s"=> \$id,
	    "project=s"=> \$project,	    
	    "buildSubDir=s"=> \$buildSubDir,
            "abbrev=s"=> \$abbrev,
            "ebiFtpUser=s"=> \$ebiFtpUser,
            "ebiFtpPassword=s"=> \$ebiFtpPassword,	    
            "storageDir=s"=> \$storageDir,
            "outputFile=s"=> \$outputFile);

open(OUT,">$outputFile");

if ($method =~  /^Uniprot/) { 
    `wget "https://rest.uniprot.org/uniprotkb/stream?compressed=true&format=fasta&query=proteome%3A${id}" --tries=5 --output-document ./$abbrev.fasta.gz`;
    `gunzip $abbrev.fasta.gz`;
    `grep ">" $abbrev.fasta > newHeaders.txt`;
    `sort newHeaders.txt -o sortedHeaders.txt`;
	
    if (-e "/storage/$abbrev.txt") {
        my $needsUpdate = `diff /storage/$abbrev.txt ./sortedHeaders.txt -q`;

	if (length($needsUpdate) != 0) {
	    `cp sortedHeaders.txt /storage/$abbrev.txt`;
	    print OUT "$abbrev\n";
        }

    }

    else {
        `cp sortedHeaders.txt /storage/$abbrev.txt`;
        print OUT "$abbrev\n";
    }
}

elsif ($method =~  /^Ebi/) {
    `wget --ftp-user ${ebiFtpUser} --ftp-password ${ebiFtpPassword} -O ${abbrev}.sql.gz ftp://ftp-private.ebi.ac.uk:/EBIout/${buildSubDir}/coredb/${project}/${id}.sql.gz`;

    if (-e "/storage/$abbrev.sql.gz") {
        my $needsUpdate = `diff /storage/$abbrev.sql.gz ./$abbrev.sql.gz -q`;

        if (length($needsUpdate) != 0) {
            `cp ${abbrev}.sql.gz /storage/${abbrev}.sql.gz`;
            print OUT "$abbrev\n";
        }
    }

    else {
        `cp ${abbrev}.sql.gz /storage/${abbrev}.sql.gz`;
        print OUT "$abbrev\n";
    }
}

elsif ($method =~  /^EuPath/) {

    `wget https://${project}.org/${id}/service/record-types/transcript/searches/GenesByGeneType/reports/sequence"> --tries=5 --mirror --no-parent --no-directories --no-host-directories --cut-dirs=4 --output-document=${abbrev}.fasta --post-data '{ "searchConfig": { "parameters": { "organism": "[\"${id}\"]", "geneType": "[\"protein coding\"]", "includePseudogenes": "No" }, "wdkWeight": 10 }, "reportConfig": { "attachmentType": "plain", "deflineType": "full", "deflineFields": [ "gene_id", "organism", "description" ], "sequenceFormat": "fixed_width", "basesPerLine": 60, "type": "protein", "reverseAndComplement": false, "upstreamAnchor": "Start", "upstreamSign": "plus", "upstreamOffset": 0, "downstreamAnchor": "End", "downstreamSign": "plus", "downstreamOffset": 0, "startAnchor3": "DownstreamFromStart", "startOffset3": 0, "endAnchor3": "UpstreamFromEnd", "endOffset3": 0, "dnaComponent": "exon", "transcriptComponent": "five_prime_utr", "proteinFeature": "interpro", "splicedGenomic": "cds" }}' --header 'content-type: application/json'`;

    `grep ">" $abbrev.fasta > newHeaders.txt`;
    `sort newHeaders.txt -o sortedHeaders.txt`;

    if (-e "/storage/$abbrev.txt") {
        my $needsUpdate = `diff /storage/$abbrev.txt ./sortedHeaders.txt -q`;

	if (length($needsUpdate) != 0) {
	    `cp sortedHeaders.txt /storage/$abbrev.txt`;
	    print OUT "$abbrev\n";
        }

    }

    else {
        `cp sortedHeaders.txt /storage/$abbrev.txt`;
        print OUT "$abbrev\n";
    }
    
}

else {
    die "Line needs to start with Uniprot,Ebi or EuPath\n";
}

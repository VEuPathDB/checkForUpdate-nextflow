#!/usr/bin/env nextflow
nextflow.enable.dsl=2

process downloadAndCheck {
  container = 'veupathdb/checkforupdate:1.0.0'

  input:
    tuple val(method), val(id), val(project), val(buildSubDir), val(abbrev)
    val ebiFtpUser
    val ebiFtpPassword

  output:
    path 'needsUpdate.txt'         

  script:
    template 'checkForUpdates.bash'
}

workflow checkForUpdate {
  take:
    datasets

  main:

    downloadAndCheckResults = downloadAndCheck(datasets, params.ebiFtpUser, params.ebiFtpPassword)
    downloadAndCheckResults.collectFile(name: 'needsUpdate.txt', storeDir: params.outputDir)
        
}
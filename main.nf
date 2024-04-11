#!/usr/bin/env nextflow
nextflow.enable.dsl=2

//--------------------------------------------------------------------------
// Param Checking
//--------------------------------------------------------------------------

if(!params.inputFile) {
  throw new Exception("Missing params.inputFile")
}
else {
  datasets_qch = Channel.fromPath(params.inputFile).splitCsv(sep: ',')
}
if(!params.ebiFtpUser) {
  throw new Exception("Missing params.ebiFtpUser")
}
if(!params.ebiFtpPassword) {
  throw new Exception("Missing params.ebiFtpPassword")
}

//--------------------------------------------------------------------------
// Includes
//--------------------------------------------------------------------------

include { checkForUpdate } from './modules/checkForUpdate.nf'

//--------------------------------------------------------------------------
// Main Workflow
//--------------------------------------------------------------------------

workflow {
  checkForUpdate(datasets_qch)
}
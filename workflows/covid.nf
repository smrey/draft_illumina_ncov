#!/usr/bin/env nextflow

// enable dsl2
nextflow.preview.dsl = 2

// import modules
include {mapReads_bwa} from '../modules/mapReadsBwa_covid.nf' params(params)

workflow covid {
    take:
        TrimmedReads
    main:
        mapReads_bwa(TrimmedReads)
}
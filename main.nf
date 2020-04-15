#!/usr/bin/env nextflow

// enable dsl2
nextflow.preview.dsl = 2

// import modules
include {readsTrimming_trimgalore} from './modules/readsTrimming_covid.nf' params(params)
include {mapReads_bwa} from './modules/mapReadsBwa_covid.nf' params(params)
include {trimAlignments_python} from './modules/trimAlignments_python.nf' params(params)
include {trimAlignments_ivar} from './modules/trimAlignments_ivar.nf' params(params)
include {callVariants_ivar} from './modules/callVariants_ivar.nf' params(params)
include {callVariants_lofreq} from './modules/callVariants_lofreq.nf' params(params)
include {callVariants_varscan} from './modules/callVariants_varscan.nf' params(params)
include {callVariants_bcftools} from './modules/callVariants_bcftools.nf' params(params)
include {callVariants_bcftools_old} from './modules/callVariants_bcftools_old.nf' params(params)
include {filterVariants_bcftools} from './modules/filterVariants_bcftools.nf' params(params)
include {coverageRefSites_bedtools} from './modules/coverageRefSites_bedtools.nf' params(params)
include {lowCoverageSites_python} from './modules/lowCoverageSites_python.nf' params(params)
include {flagLowAlleleFreqVariants_lofreq} from './modules/flagLowAlleleFreqVariants_lofreq.nf' params(params)
include {filterIndels_lofreq} from './modules/filterIndels_lofreq.nf' params(params)
include {editVariants_bcftools} from './modules/editVariants_bcftools.nf' params(params)
include {editVariants_lofreq} from './modules/editVariants_lofreq.nf' params(params)
include {primerSitesVariants_bedtools} from './modules/primerSitesVariants_bedtools.nf' params(params)
include {filterVariants_lofreq} from './modules/filterVariants_lofreq.nf' params(params)
include {filterVariants_python} from './modules/filterVariants_python.nf' params(params)
include {furtherFilterVariants_python} from './modules/furtherFilterVariants_python.nf' params(params)
include {mergeVcf_bcftools} from './modules/mergeVcf_bcftools.nf' params(params)
include {mergeVcf_bcftools_lofreq} from './modules/mergeVcf_bcftools_lofreq.nf' params(params)
include {mergeVcf_bcftools_python} from './modules/mergeVcf_bcftools_python.nf' params(params)
include {removeFilteredVariants} from './modules/removeFilteredVariants.nf' params(params)
include {maskLowCoverageBases_python} from './modules/maskLowCoverageBases_python.nf' params(params)
include {createConsensus_bcftools} from './modules/createConsensus_bcftools.nf' params(params)
include {createConsensus_lofreq} from './modules/createConsensus_lofreq.nf' params(params)
include {maskLowCoverageBases_lofreq} from './modules/maskLowCoverageBases_lofreq.nf' params(params)
include {maskLowCoverageBases_bcftools} from './modules/maskLowCoverageBases_bcftools.nf' params(params)

workflow {
    runDir = "${params.dir}"
    allFastq = "${runDir}/*_R{1,2}_001.fastq.gz"
    InputReads = Channel.fromFilePairs( "${allFastq}", flat: true )
    ReferenceGenome = Channel.fromPath("./${params.reference_genome}")
    PrimerScheme = Channel.fromPath("./${params.primer_scheme}")
    PrimerSchemeIvar = Channel.fromPath("./${params.primer_scheme_ivar}")

    main:
    readsTrimming_trimgalore(InputReads)
    mapReads_bwa(readsTrimming_trimgalore.out.combine(ReferenceGenome))
    trimAlignments_ivar(mapReads_bwa.out.combine(PrimerSchemeIvar))
    //callVariants_ivar(trimAlignments_ivar.out.bams.combine(ReferenceGenome))
    callVariants_lofreq(trimAlignments_ivar.out.bam.combine(ReferenceGenome))
    //callVariants_varscan(trimAlignments_ivar.out.bams.combine(ReferenceGenome))
    //callVariants_bcftools(trimAlignments_ivar.out.bams.combine(ReferenceGenome))
    //callVariants_bcftools_old(trimAlignments_ivar.out.bams.combine(ReferenceGenome))
    //coverageRefSites_bedtools(trimAlignments_ivar.out.bams)
    lowCoverageSites_python(trimAlignments_ivar.out.bams.combine(ReferenceGenome)) //depth masking
    //editVariants_bcftools(callVariants_bcftools.out.vcf)
    //editVariants_lofreq_old(callVariants_lofreq.out.vcf) //MOVE THIS TO LATER ON
    flagLowAlleleFreqVariants_lofreq(callVariants_lofreq.out.vcf)
    primerSitesVariants_bedtools(flagLowAlleleFreqVariants_lofreq.out.vcf.combine(PrimerScheme))
    filterVariants_lofreq(primerSitesVariants_bedtools.out.for_strandbias_filtering.join(primerSitesVariants_bedtools.out.not_for_strandbias_filtering, by: 0))
    //filterVariants_python(primerSitesVariants_bedtools.out.for_strandbias_filtering.join(primerSitesVariants_bedtools.out.not_for_strandbias_filtering, by: 0))
    ////mergeVcf_bcftools(filterVariants_python.out.pass_strand.join(filterVariants_python.out.pass_filter, by: 0).join(filterVariants_python.out.fail_strand.join(filterVariants_python.out.fail_filter, by: 0), by: 0)) //merge filtered calls
    mergeVcf_bcftools_lofreq(filterVariants_lofreq.out.strand_filtered.join(filterVariants_lofreq.out.nostrand_filtered))
    // Placeholder for any additional filtering required
    furtherFilterVariants_python(mergeVcf_bcftools_lofreq.out.lofreq_merged_vcf)
    mergeVcf_bcftools_python(furtherFilterVariants_python.out.pass_vcf.join(furtherFilterVariants_python.out.fail_vcf))
    //createConsensus_bcftools(editVariants_bcftools.out.edited_vcf.combine(ReferenceGenome))
    ////editVariants_lofreq(mergeVcf_bcftools.out.merged_pass_vcf)
    //filterIndels_lofreq(mergeVcf_bcftools_python.out.python_merged_vcf) // Only outputs indels- fix later if go this route
    editVariants_lofreq(mergeVcf_bcftools_python.out.python_merged_vcf)
    removeFilteredVariants(editVariants_lofreq.out.edited_vcf)
    createConsensus_bcftools(removeFilteredVariants.out.pass_vcf.join(lowCoverageSites_python.out.low_coverage, by:0).combine(ReferenceGenome))
    ////maskLowCoverageBases_python(lowCoverageSites_python.out.low_coverage.join(mergeVcf_bcftools.out.merged_fail_vcf, by: 0).combine(ReferenceGenome)) //apply depth mask and failed variants
    ////createConsensus_bcftools(editVariants_lofreq.out.edited_vcf.join(lowCoverageSites_python.out.low_coverage, by:0).combine(ReferenceGenome))
}
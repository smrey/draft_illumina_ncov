process primerSitesVariants_bedtools {
 /**
    * Filters 
    * Replaced masking N with n for consistency with output from bcftools
    * @input 
    * @output 
    */
    
    tag { dataset_id }

    publishDir "${params.output}/${task.process}", pattern: '*.vcf', mode: 'copy'

    input:
        tuple(dataset_id, path(vcf), path(primer_scheme))

    output:
        tuple dataset_id, path("${dataset_id}_strandfilter.vcf"), emit: for_strandbias_filtering
        tuple dataset_id, path("${dataset_id}_nostrandfilter.vcf"), emit: not_for_strandbias_filtering


    script:
    """
    bedtools sort -i ${primer_scheme} > primers.sorted.bed
    bedtools merge -i primers.sorted.bed > primers.merged.sorted.bed 
    bedtools intersect -header -v -a ${vcf} -b primers.merged.sorted.bed >${dataset_id}_strandfilter.vcf
    bedtools intersect -header -a ${vcf} -b primers.merged.sorted.bed >${dataset_id}_nostrandfilter.vcf
    """

}

process maskLowCoverageBases_bcftools {

    /**
    * Filters 
    * Replaced masking N with n for consistency with output from bcftools
    * @input 
    * @output 
    */
    
    tag { dataset_id }

    publishDir "${params.output}/${task.process}", pattern: '*.fasta', mode: 'copy'

    input:
        tuple(dataset_id, path("${dataset_id}_lowcoverage_merged.bed"), path("${dataset_id}_bcftools_interim.fasta"))

    output:
        tuple dataset_id, path("${dataset_id}_bcftools.fasta"), emit: consensus


    script:
    """
    bedtools maskfasta -mc 'n' -fi ${dataset_id}_bcftools_interim.fasta -bed ${dataset_id}_lowcoverage_merged.bed -fo ${dataset_id}_bcftools.fasta
    """

}
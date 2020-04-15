process maskLowCoverageBases_python {
    
        /**
    * Filters 
    * @input 
    * @output 
    */
    
    tag { dataset_id }

    publishDir "${params.output}/${task.process}", pattern: '*.fasta', mode: 'copy'

    input:
        tuple(dataset_id, path("${dataset_id}_coverage_mask.txt"), path("${dataset_id}_failcombined.vcf"), path(ref_genome))

    output:
        tuple dataset_id, path("${dataset_id}.preconsensus.fasta"), emit: preconsensus


    script:
    """
    mask.py ${ref_genome} ${dataset_id}_coverage_mask.txt ${dataset_id}_failcombined.vcf ${dataset_id}.preconsensus.fasta
    """


}
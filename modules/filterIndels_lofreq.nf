process filterIndels_lofreq {
    /**
    * Filters 
    * De
    * @input 
    * @output 
    */
    
    tag { dataset_id }

    publishDir "${params.output}/${task.process}", pattern: '*.vcf', mode: 'copy'

    input:
        tuple(dataset_id, path(vcf))

    output:
        tuple dataset_id, path("${dataset_id}.indelfiltered.vcf"), emit: indel_filtered
    
    script:
        """

        lofreq filter --only-indels --af-min 0.75 \
        --in ${vcf} \
        --out ${dataset_id}.indelfiltered.vcf --print-all
        """

}
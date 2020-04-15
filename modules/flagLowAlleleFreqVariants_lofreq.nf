process flagLowAlleleFreqVariants_lofreq {
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
        tuple dataset_id, path("${dataset_id}_flaglow.vcf"), emit: vcf
    
    script:
        """
        # Switch off default filters
        lofreq filter --no-defaults --cov-min 20 --af-min 0.25 \
        --in ${vcf} \
        --out ${dataset_id}_flaglow.vcf --print-all
        """
}
process editVariants_lofreq {
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
        tuple dataset_id, path("${dataset_id}.edited.vcf"), emit: edited_vcf
    
    script:
        """
        vcf_edit.py -v ${vcf} -c lofreq -o ${dataset_id}.edited.vcf
        """

}
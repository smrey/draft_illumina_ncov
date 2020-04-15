process editVariants_lofreq_old {
    /**
    * Filters 
    * De
    * @input 
    * @output 
    */
    
    tag { dataset_id }

    publishDir "${params.output}/${task.process}", pattern: '*.vcf', mode: 'copy'

    input:
        tuple(dataset_id, path("${dataset_id}_lofreq.vcf"))

    output:
        tuple dataset_id, path("${dataset_id}_lofreq_edited.vcf"), emit: edited_vcf
    
    script:
        """
        vcf_edit.py -v ${dataset_id}_lofreq.vcf -c lofreq
        """

}
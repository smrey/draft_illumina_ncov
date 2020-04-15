process editVariants_python {
    /**
    * Filters 
    * De
    * @input 
    * @output 
    */
    
    tag { dataset_id }

    publishDir "${params.output}/${task.process}", pattern: '*.vcf', mode: 'copy'

    input:
        tuple(dataset_id, path("${dataset_id}_bcftools.vcf"), "${variant_caller}")

    output:
        tuple dataset_id, path("${dataset_id}_${variant_caller}_edited.vcf"), emit: edited_vcf
    
    script:
        """
        vcf_edit.py -v ${dataset_id}_${variant_caller}.vcf -c ${variant_caller}
        """

}
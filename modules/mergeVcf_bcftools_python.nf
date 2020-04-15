process mergeVcf_bcftools_python {
    /**
    * Merge filtered calls
    * De
    * @input 
    * @output 
    */
    
    tag { dataset_id }

    publishDir "${params.output}/${task.process}", pattern: '*.vcf', mode: 'copy'

    input:
        tuple(dataset_id, path(first_vcf), path(second_vcf)) 

    output:
        tuple dataset_id, path("${dataset_id}.pythonfiltered.combined.vcf"), emit: python_merged_vcf


    script:
    """
    bgzip ${first_vcf}
    bgzip ${second_vcf}
    bcftools index ${first_vcf}.gz
    bcftools index ${second_vcf}.gz
    bcftools concat ${first_vcf}.gz ${second_vcf}.gz \
    | bcftools sort - > ${dataset_id}.pythonfiltered.combined.vcf
    """
}

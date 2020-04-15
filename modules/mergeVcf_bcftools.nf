process mergeVcf_bcftools {
    /**
    * Merge filtered calls
    * De
    * @input 
    * @output 
    */
    
    tag { dataset_id }

    publishDir "${params.output}/${task.process}", pattern: '*.vcf', mode: 'copy'

    input:
        tuple(dataset_id, path("${dataset_id}.passstrand.vcf"), path("${dataset_id}.passfilter.vcf"), path("${dataset_id}.failstrand.vcf"), path("${dataset_id}.failfilter.vcf")) 

    output:
        tuple dataset_id, path("${dataset_id}_passcombined.vcf"), emit: merged_pass_vcf
        tuple dataset_id, path("${dataset_id}_failcombined.vcf"), emit: merged_fail_vcf


    script:
    """
    bgzip ${dataset_id}.passstrand.vcf
    bgzip ${dataset_id}.passfilter.vcf
    bcftools index ${dataset_id}.passstrand.vcf.gz
    bcftools index ${dataset_id}.passfilter.vcf.gz
    bcftools concat ${dataset_id}.passstrand.vcf.gz ${dataset_id}.passfilter.vcf.gz \
    | bcftools sort - > ${dataset_id}_passcombined.vcf
    bgzip ${dataset_id}.failstrand.vcf
    bgzip ${dataset_id}.failfilter.vcf
    bcftools index ${dataset_id}.failstrand.vcf.gz
    bcftools index ${dataset_id}.failfilter.vcf.gz
    bcftools concat ${dataset_id}.failstrand.vcf.gz ${dataset_id}.passfilter.vcf.gz \
    | bcftools sort - > ${dataset_id}_failcombined.vcf
    """
}

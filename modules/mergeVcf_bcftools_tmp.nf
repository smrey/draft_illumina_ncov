process mergeVcf_bcftools_tmp {
    /**
    * Merge filtered calls
    * De
    * @input 
    * @output 
    */
    
    tag { dataset_id }

    publishDir "${params.output}/${task.process}", pattern: '*.vcf', mode: 'copy'

    input:
        tuple(dataset_id, path("${dataset_id}.strandfiltered.vcf"), path("${dataset_id}.nostrandfiltered.vcf")) 

    output:
        tuple dataset_id, path("${dataset_id}.combined.vcf"), emit: merged_vcf


    script:
    """
    bgzip ${dataset_id}.strandfiltered.vcf
    bgzip ${dataset_id}.nostrandfiltered.vcf
    bcftools index ${dataset_id}.strandfiltered.vcf.gz
    bcftools index ${dataset_id}.nostrandfiltered.vcf.gz
    bcftools concat ${dataset_id}.strandfiltered.vcf.gz ${dataset_id}.nostrandfiltered.vcf.gz \
    | bcftools sort - > ${dataset_id}.combined.vcf
    """
}

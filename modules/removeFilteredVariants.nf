process removeFilteredVariants {

    /**
    * Merge filtered calls
    * De
    * @input 
    * @output 
    */
    
    tag { dataset_id }

    publishDir "${params.output}/${task.process}", pattern: '*.vcf', mode: 'copy'

    input:
        tuple(dataset_id, path(vcf)) 

    output:
        tuple dataset_id, path("${dataset_id}.pass.vcf"), emit: pass_vcf
        tuple dataset_id, path("${dataset_id}.fail.vcf"), emit: fail_vcf


    script:
    """
    bgzip ${vcf}
    bcftools index ${vcf}.gz
    bcftools view -f .,PASS ${vcf}.gz -O v -o ${dataset_id}.pass.vcf
    bcftools view -f min_af_0.250000,min_dp_20,sb_fdr,snvqual_bonf,indelqual_bonf,lowaf_indel ${vcf}.gz -O v -o ${dataset_id}.fail.vcf
    """

}
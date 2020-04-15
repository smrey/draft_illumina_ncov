process filterVariants_bcftools {
    /**
    * Filters 
    * De
    * @input 
    * @output 
    */
    
    tag { dataset_id }

    publishDir "${params.output}/${task.process}", pattern: '*.txt', mode: 'copy'
    publishDir "${params.output}/${task.process}", pattern: '*.vcf', mode: 'copy'

    input:
        tuple(dataset_id, path("${dataset_id}_lofreq.vcf"))

    output:
        tuple(dataset_id, path("${dataset_id}_removed_variants.vcf"), path("${dataset_id}_variants.vcf")) //optional true
        path("${dataset_id}*.txt") optional true
    
    script:
        """
        
        bcftools filter -i "AF<0.25" -O b -o ${dataset_id}_removed_variants.vcf ${dataset_id}.vcf.gz
        
        """

}
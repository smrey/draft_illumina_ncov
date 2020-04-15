process furtherFilterVariants_python {
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
        tuple dataset_id, path("${dataset_id}.pass.vcf"), emit: pass_vcf
        tuple dataset_id, path("${dataset_id}.fail.vcf"), emit: fail_vcf
    
    script:
        """
        #vcf_filter.py --illumina --primer_site ${dataset_id}_strandfilter.vcf ${dataset_id}.passstrand.vcf ${dataset_id}.failstrand.vcf
        vcf_filter.py --illumina ${vcf} ${dataset_id}.pass.vcf ${dataset_id}.fail.vcf
        """

}
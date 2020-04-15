process filterVariants_python {
    /**
    * Filters 
    * De
    * @input 
    * @output 
    */
    
    tag { dataset_id }

    publishDir "${params.output}/${task.process}", pattern: '*.vcf', mode: 'copy'

    input:
        tuple(dataset_id, path("${dataset_id}_strandfilter.vcf"), path("${dataset_id}_nostrandfilter.vcf"))

    output:
        tuple dataset_id, path("${dataset_id}.passstrand.vcf"), emit: pass_strand
        tuple dataset_id, path("${dataset_id}.failstrand.vcf"), emit: fail_strand
        tuple dataset_id, path("${dataset_id}.passfilter.vcf"), emit: pass_filter 
        tuple dataset_id, path("${dataset_id}.failfilter.vcf"), emit: fail_filter
    
    script:
        """
        vcf_filter_old.py --illumina --strand_bias ${dataset_id}_strandfilter.vcf ${dataset_id}.passstrand.vcf ${dataset_id}.failstrand.vcf
        vcf_filter_old.py --illumina ${dataset_id}_nostrandfilter.vcf ${dataset_id}.passfilter.vcf ${dataset_id}.failfilter.vcf
        """

}
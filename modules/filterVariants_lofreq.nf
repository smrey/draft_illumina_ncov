process filterVariants_lofreq {
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
        tuple dataset_id, path("${dataset_id}.strandfiltered.vcf"), emit: strand_filtered
        tuple dataset_id, path("${dataset_id}.nostrandfiltered.vcf"), emit: nostrand_filtered
    
    script:
        """
        # Default fdr strand bias and quality filter applied
        lofreq filter --sb-incl-indels --snvqual-mtc bonf --indelqual-mtc bonf \
        --in ${dataset_id}_strandfilter.vcf \
        --out ${dataset_id}.strandfiltered.vcf --print-all
        # Switch off default filters
        lofreq filter --no-defaults --snvqual-mtc bonf --indelqual-mtc bonf \
        --in ${dataset_id}_nostrandfilter.vcf \
        --out ${dataset_id}.nostrandfiltered.vcf --print-all
        """

}
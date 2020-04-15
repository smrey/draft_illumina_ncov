process callVariants_varscan {
    /**
    * Uses samtools to generate an mpileup from the primer trimmed bam.
    * Samtools options: don't skip sequences without properly paired flag set, maximum depth of reads to consider- all, 
    * minimum base quality of 10 for a base to be considered, minimum mapping quality of 20 for an alignment to be used.
    * Calls variants from primer trimmed bam using varscan (https://github.com/dkoboldt/varscan)(https://wiki.bits.vib.be/index.php/Varscan2)
    * mpileup to SNP option used, minimum coverage and reads to call set to 1. Otherwise default options.
    * remove strand filter for consistency with other callers- filtering to be applied later
    * @input 
    * @output 
    */
    
    tag { dataset_id }

    publishDir "${params.output}/${task.process}", pattern: '*.txt', mode: 'copy'
    publishDir "${params.output}/${task.process}", pattern: '*.vcf', mode: 'copy'

    input:
        tuple(dataset_id, path("${dataset_id}.primertrimmed.sorted.bam"), path("${dataset_id}.primertrimmed.sorted.bam.bai"), path(ref_genome))

    output:
        tuple(dataset_id, path("${dataset_id}_varscan.vcf")) optional true
        path("${dataset_id}_varscanerrlog.txt") optional true
    
    script:
        """
        samtools mpileup -A -d 1000000 -f ${ref_genome} -Q 10 -q 20 ${dataset_id}.primertrimmed.sorted.bam \
        | varscan mpileup2cns --min-coverage 1 --min-reads 1 --min-avg-qual 10  \
        --strand-filter 0 --output-vcf 1 \
         > ${dataset_id}_varscan.vcf \
         2> ${dataset_id}_varscanerrlog.txt
        """

}
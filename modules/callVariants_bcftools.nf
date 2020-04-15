process callVariants_bcftools {
    /**
    * Uses bcftools to generate a pileup (http://www.htslib.org/doc/samtools.html)
    * Bcftools mpileup options: don't skip sequences without properly paired flag set, maximum depth of reads to consider 300000, 
    * minimum base quality of 10 for a base to be considered, minimum mapping quality of 20 for an alignment to be used.
    * Calls variants from primer trimmed bam using bcftools (http://samtools.github.io/bcftools/bcftools.html)
    * Options: keep all alternate alleles (-A), - min sample depth 1,
    * ploidy of 1 
    * @input 
    * @output 
    */
    
    tag { dataset_id }

    publishDir "${params.output}/${task.process}", pattern: '*.txt', mode: 'copy'
    publishDir "${params.output}/${task.process}", pattern: '*.vcf', mode: 'copy'

    input:
        tuple(dataset_id, path("${dataset_id}.primertrimmed.sorted.bam"), path("${dataset_id}.primertrimmed.sorted.bam.bai"), path(ref_genome))

    output:
        tuple dataset_id, path("${dataset_id}_bcftools.vcf"), emit: vcf
        path("${dataset_id}*.txt") optional true
    
    script:
        """
        bcftools mpileup -a INFO/AD,FORMAT/AD -d 1000000 -A -f ${ref_genome} -Q 10 -q 20 ${dataset_id}.primertrimmed.sorted.bam \
        | bcftools call -Am --ploidy 1 -o ${dataset_id}_bcftools.vcf \
        2>&1 > ${dataset_id}_bcflog.txt
        """

}
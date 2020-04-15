process callVariants_lofreq {
    /**
    * Calls variants from primer trimmed bam using lofreq (https://github.com/CSB5/lofreq)
    * Options used (note lofreq call-parallel can be used with option --pp-threads)
    * min base quality score 10, min mapping quality score 20, removed default filtering, 
    * don't skip bases where mate is unaligned, max depth of reads to use 1000000
    * @input 
    * @output 
    */
    
    tag { dataset_id }

    publishDir "${params.output}/${task.process}", pattern: '*.vcf', mode: 'copy'

    input:
        tuple(dataset_id, path("${dataset_id}.primertrimmed.sorted.bam"), path(ref_genome))

    output:
        tuple dataset_id, path("${dataset_id}_lofreq.vcf"), emit: vcf
    
    script:
        """
        # Pipe removed due to segfault bug
        lofreq indelqual --dindel ${dataset_id}.primertrimmed.sorted.bam -f ${ref_genome} \
        --out ${dataset_id}.realigned.bam
        lofreq call --call-indels --min-bq 10 --min-alt-bq 10 --min-mq 20 --no-default-filter \
        --use-orphan --max-depth 1000000 --min-cov 1 -f ${ref_genome} -o ${dataset_id}_lofreq.vcf \
        ${dataset_id}.realigned.bam
        """

}
process callVariants_ivar {
    /**
    * Uses samtools to generate a pileup (http://www.htslib.org/doc/samtools.html)
    * Samtools options: don't skip sequences without properly paired flag set, maximum depth of reads to consider- all, 
    * minimum base quality of 10 for a base to be considered, minimum mapping quality of 20 for an alignment to be used.
    * Calls variants from primer trimmed bam using ivar (https://github.com/andersen-lab/ivar)
    * Ivar options: base quality threshold:20, majority/most common base called, call variants if coverage exceeds 1,
    * print - when no depth coverage
    * @input 
    * @output 
    */
    
    tag { dataset_id }

    publishDir "${params.output}/${task.process}", pattern: '*.txt', mode: 'copy'
    publishDir "${params.output}/${task.process}", pattern: '*.tsv*', mode: 'copy'

    input:
        tuple(dataset_id, path("${dataset_id}.primertrimmed.sorted.bam"), path("${dataset_id}.primertrimmed.sorted.bam.bai"), path(ref_genome))

    output:
        tuple(dataset_id, path("${dataset_id}_ivar.tsv")) optional true
        path("${dataset_id}_ivar_calllog.txt") optional true
    
    script:
        """
        samtools mpileup -A -d 1000000 -f ${ref_genome} -Q 10 -q 20 ${dataset_id}.primertrimmed.sorted.bam \
        | ivar variants -p ${dataset_id}_ivar -q 10 -t 0 -m 1 -r ${ref_genome}  \
        2>&1 > ${dataset_id}_ivar_calllog.txt
        """

}
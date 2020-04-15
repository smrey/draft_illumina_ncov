process mapReads_bwa {
    /**
    * Maps trimmed paired fastq using BWA (http://bio-bwa.sourceforge.net/)
    * Uses samtools to convert to BAM, sort and index sorted BAM (http://www.htslib.org/doc/samtools.html)
    * @input 
    * @output 
    */

    tag { dataset_id }

    publishDir "${params.output}/${task.process}", pattern: '*.bam*', mode: 'copy'

    cpus 5
    memory '8 GB'

    input:
        tuple(dataset_id, path(forward), path(reverse), path(ref_genome))

    output:
        tuple(dataset_id, path("${dataset_id}.sorted.bam"), path("${dataset_id}.sorted.bam.bai")) optional true

    script:
        """
        bwa index ${ref_genome}
        bwa mem ${ref_genome} ${forward} ${reverse} | samtools view -bS | \
        samtools sort -o ${dataset_id}.sorted.bam
        samtools index ${dataset_id}.sorted.bam
        """
}


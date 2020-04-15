process trimAlignments_python {
    /**
    * Trims primers from input primer file  (https://github.com/artic-network/fieldbioinformatics/blob/master/artic/align_trim.py)
    * Uses samtools to convert to BAM and sort (-T writes temp files to a specified prefix). 
    * Indexes sorted bam file (http://www.htslib.org/doc/samtools.html)
    * @input 
    * @output 
    */

    tag { dataset_id }

    publishDir "${params.output}/${task.process}", pattern: '*alignreport.*', mode: 'copy'
    publishDir "${params.output}/${task.process}", pattern: '*primertrimmed.sorted.bam*', mode: 'copy'

    input:
        tuple(dataset_id, path("${dataset_id}.sorted.bam"), path("${dataset_id}.sorted.bam.bai"), path(primer_bed))

    output:
        tuple(dataset_id, path("${dataset_id}.primertrimmed.sorted.bam"), path("${dataset_id}.primertrimmed.sorted.bam.bai")) optional true
        tuple(path("${dataset_id}.alignreport.txt"), path("${dataset_id}.alignreport.er")) optional true

    script:
        """
        align_trim.py "${primer_bed}" --report "${dataset_id}.alignreport.txt" < "${dataset_id}.sorted.bam" 2> "${dataset_id}.alignreport.er" | \
        samtools view -bS - | samtools sort -T "${dataset_id}" - -o "${dataset_id}.primertrimmed.sorted.bam"
        samtools index "${dataset_id}".primertrimmed.sorted.bam
        """

}

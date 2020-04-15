process trimAlignments_ivar {
    /**
    * Remove unmapped reads before primer trimming using samtools (http://www.htslib.org/doc/samtools.html)- iVar segfaults
    * Trims primers from input primer file  (https://github.com/andersen-lab/ivar)
    * Uses samtools to convert to BAM and sort (-T writes temp files to a specified prefix). 
    * Indexes sorted bam file (http://www.htslib.org/doc/samtools.html)
    * @input 
    * @output 
    */

    tag { dataset_id }

    publishDir "${params.output}/${task.process}", pattern: '*alignreport.*', mode: 'copy'
    publishDir "${params.output}/${task.process}", pattern: '*primertrimmed.sorted.bam*', mode: 'copy'

    input:
        tuple(dataset_id, path("${dataset_id}.sorted.bam"), path("${dataset_id}.sorted.bam.bai"), path(primer_bed_ivar))

    output:
        tuple dataset_id, path("${dataset_id}.primertrimmed.sorted.bam"), emit: bam
        tuple dataset_id, path("${dataset_id}.primertrimmed.sorted.bam"), path("${dataset_id}.primertrimmed.sorted.bam.bai"), emit: bams
        tuple path("${dataset_id}.alignreport.txt"), path("${dataset_id}.alignreport.er"), emit: reports
    
    script:
        """
        samtools view -F 4 "${dataset_id}.sorted.bam" -o "${dataset_id}.nounmapped.sorted.bam"
        ivar trim -i "${dataset_id}.nounmapped.sorted.bam" -b "${primer_bed_ivar}" -p "${dataset_id}.primertrimmed" -q 0 -m 1 -e \
        >"${dataset_id}.alignreport.txt" 2> "${dataset_id}.alignreport.er"
        samtools sort -T "${dataset_id}" -o "${dataset_id}.primertrimmed.sorted.bam" "${dataset_id}.primertrimmed.bam"
        samtools index "${dataset_id}".primertrimmed.sorted.bam
        """
}
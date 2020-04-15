process lowCoverageSites_python {
    /**
    * Filters 
    * De
    * Use samtools for pre-filtering to keep mapping quality filtering in line with variant calls
    * @input 
    * @output 
    */
    
    tag { dataset_id }

    publishDir "${params.output}/${task.process}", pattern: '*.txt', mode: 'copy'

    input:
        tuple(dataset_id, path("${dataset_id}.primertrimmed.sorted.bam"), path("${dataset_id}.primertrimmed.sorted.bam.bai"), path(ref_genome))

    output:
        tuple dataset_id, path("${dataset_id}_coverage_mask.txt"), emit: low_coverage


    script:
    """
    make_depth_mask.py --depth ${params.coverage_threshold} ${ref_genome} \
    ${dataset_id}.primertrimmed.sorted.bam ${dataset_id}_coverage_mask.txt
    """
}

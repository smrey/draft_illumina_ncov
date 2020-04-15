process coverageRefSites_bedtools {
    /**
    * Filters 
    * De
    * Use samtools for pre-filtering to keep mapping quality filtering in line with variant calls
    * @input 
    * @output 
    */
    
    tag { dataset_id }

    publishDir "${params.output}/${task.process}", pattern: '*.bed', mode: 'copy'

    input:
        tuple(dataset_id, path("${dataset_id}.primertrimmed.sorted.bam"), path("${dataset_id}.primertrimmed.sorted.bam.bai"))

    output:
        tuple dataset_id, path("${dataset_id}_lowcoverage_merged.bed"), emit: low_coverage


    shell:
    '''
    # Obtain coverage over whole BAM
    #samtools view -b -q 20 !{dataset_id}.primertrimmed.sorted.bam \
    #| bedtools genomecov -bga -ibam - > !{dataset_id}_coverage.txt
    bedtools genomecov -bga -ibam !{dataset_id}.primertrimmed.sorted.bam > !{dataset_id}_coverage.txt
    # Locate regions of coverage less than the threshold value
    while read line; do count=$(echo $line | cut -d' ' -f4)
        if [ $count -lt !{params.coverage_threshold} ] 
            then echo $line
        fi
    done < !{dataset_id}_coverage.txt > !{dataset_id}_lowcoverage.txt
    # Convert bedgraph format to bed (replace space delim with tab delim)
    sed "s/ /\\t/g" !{dataset_id}_lowcoverage.txt > !{dataset_id}_lowcoverage.bed
    # Merge bed
    bedtools merge -i !{dataset_id}_lowcoverage.bed > !{dataset_id}'_lowcoverage_merged.bed'
    '''
}

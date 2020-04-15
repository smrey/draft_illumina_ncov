process createConsensus_bcftools {

    /**
    * Filters 
    * De
    * @input 
    * @output 
    */
    
    tag { dataset_id }

    publishDir "${params.output}/${task.process}", pattern: '*.fasta', mode: 'copy'

    input:
        tuple(dataset_id, path("${dataset_id}_passcombined_edited.vcf"), path("${dataset_id}_coverage_mask.txt"), path(ref_genome))

    output:
        tuple dataset_id, path("${dataset_id}.consensus.fasta"), emit: consensus


    script:
    """
    bgzip ${dataset_id}_passcombined_edited.vcf
    bcftools index ${dataset_id}_passcombined_edited.vcf.gz
    bcftools consensus -f ${ref_genome} "${dataset_id}_passcombined_edited.vcf.gz" -m ${dataset_id}_coverage_mask.txt -o ${dataset_id}.consensus.fasta
    """
}
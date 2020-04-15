process createConsensus_lofreq {

    /**
    * Filters 
    * De
    * @input 
    * @output 
    */
    
    tag { dataset_id }

    publishDir "${params.output}/${task.process}", pattern: '*.fasta', mode: 'copy'

    input:
        tuple(dataset_id, path("${dataset_id}_lofreq_edited.vcf"), path(ref_genome))

    output:
        tuple dataset_id, path("${dataset_id}_lofreq_interim.fasta"), emit: interim_consensus


    script:
    """
    bgzip ${dataset_id}_lofreq_edited.vcf
    bcftools index ${dataset_id}_lofreq_edited.vcf.gz
    bcftools consensus -f ${ref_genome} ${dataset_id}_lofreq_edited.vcf.gz  > ${dataset_id}_lofreq_interim.fasta
    """
}
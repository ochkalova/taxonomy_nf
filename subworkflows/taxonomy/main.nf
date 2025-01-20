include { DIAMOND_BLASTP } from '../../modules/nf-core/diamond/blastp/main'

workflow TAXONOMY {
    take:
    proteins                    // [ val(meta), path(assembly_fasta) ]

    main:
    
    db = [[id: ""], params.taxonomy_db]
    DIAMOND_BLASTP(proteins, db, "txt", "qseqid sseqid evalue bitscore salltitles")

    emit:
    output = DIAMOND_BLASTP.out.txt
}

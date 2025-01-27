include { DIAMOND_BLASTP  } from '../../modules/nf-core/diamond/blastp/main'
include { CATPACK_CONTIGS } from '../../modules/nf-core/catpack/contigs/main'

workflow TAXONOMY {
    take:
    contigs                     // [ val(meta), path(file) ]
    proteins                    // [ val(meta), path(file) ]
    cat_db                      // [ val(meta), path(db_folder)  ]
    taxonomy_db                 // [ val(meta), path(tax_folder) ]

    main:

    Channel.of(cat_db)
        .map { meta, folder ->
            [meta, file("$folder/*.dmnd")]
        }
        .set {diamond_db}

    DIAMOND_BLASTP(proteins, diamond_db, "txt", [])

    // CAT does not use provided cat_db because alignment is already done by Diamond
    // However this option is obligatory in the CAT source python code
    CATPACK_CONTIGS(contigs, cat_db, taxonomy_db, proteins, DIAMOND_BLASTP.out.txt)

    emit:
    output = DIAMOND_BLASTP.out.txt
}

include { DIAMOND_BLASTP  } from '../../modules/nf-core/diamond/blastp/main'
include { CATPACK_CONTIGS } from '../../modules/nf-core/catpack/contigs/main'

workflow TAXONOMY {
    take:
    contigs                     // [ val(meta), path(file) ]
    proteins                    // [ val(meta), path(file) ]
    diamond_db                  // [ val(meta), path(db_folder)  ]
    taxonomy_db                 // [ val(meta), path(tax_folder) ]

    main:
    DIAMOND_BLASTP(proteins, diamond_db, "txt", [])
    // CAT does not use contigs, diamond_db and, possibly, proteins
    // However this options are obligatory in the source python CAT program
    CATPACK_CONTIGS(contigs, diamond_db, taxonomy_db, proteins, DIAMOND_BLASTP.out.txt)

    emit:
    output = DIAMOND_BLASTP.out.txt
}

include { TAXONOMY } from "../subworkflows/taxonomy/main.nf"

workflow PIPELINE {

    proteins = [[id: params.tag],params.input_proteins]
    contigs = [[id: params.tag],params.input_contigs]
    diamond_db = [[id: "CAT"],params.db_folder]
    taxonomy_db = [[id: "CAT"],params.tax_folder]

    TAXONOMY(contigs, proteins, diamond_db, taxonomy_db)

}
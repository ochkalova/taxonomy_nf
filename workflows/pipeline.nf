include { TAXONOMY } from "../subworkflows/taxonomy/main.nf"

workflow PIPELINE {

    proteins = [[id: "prot_test"],params.input_proteins]
    contigs = [[id: "contig_test"],params.input_contigs]
    diamond_db = [[id: "db_test"],params.db_folder]
    taxonomy_db = [[id: "tax_test"],params.tax_folder]

    TAXONOMY(contigs, proteins, diamond_db, taxonomy_db)

}
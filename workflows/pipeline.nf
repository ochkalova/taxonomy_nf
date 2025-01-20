include { TAXONOMY } from "../subworkflows/taxonomy/main.nf"

workflow PIPELINE {
    proteins = [[id: "test"],params.input_proteins]
    TAXONOMY(proteins)

}
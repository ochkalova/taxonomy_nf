include { TAXONOMY          } from "../subworkflows/taxonomy/main.nf"
include { samplesheetToList } from 'plugin/nf-schema'

workflow PIPELINE {

    samplesheet_ch = Channel
        .fromList(samplesheetToList(params.input, "${projectDir}/assets/schema_input.json"))
    
    taxonomy_input_ch = samplesheet_ch
        .multiMap { meta, contig, protein ->
            contigs: [ meta, contig ]
            proteins: [ meta, protein ]
        }

    diamond_db = [[id: "CAT"],params.db_folder]
    taxonomy_db = [[id: "CAT"],params.tax_folder]

    TAXONOMY(taxonomy_input_ch.contigs, taxonomy_input_ch.proteins, diamond_db, taxonomy_db)

}
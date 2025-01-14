include { MODULE } from '../../modules/local/example/main'

workflow SUBWORKFLOW {
    take:
    assembly                    // [ val(meta), path(assembly_fasta) ]

    main:
    MODULE(assembly)

    emit:
    output = MODULE.out.some_output
}

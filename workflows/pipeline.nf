include { SUBWORKFLOW } from "../subworkflows/example/main.nf"

workflow PIPELINE {

    SUBWORKFLOW()

}
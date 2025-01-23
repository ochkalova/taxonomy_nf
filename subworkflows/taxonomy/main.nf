include { DIAMOND_BLASTP } from '../../modules/nf-core/diamond/blastp/main'
include { TAXONKIT_LCA   } from '../../modules/nf-core/taxonkit/lca/main'

process REFORMAT_DIAMOND_OUTPUT {

    input:
    tuple val(meta), path(diamond_file)

    output:
    tuple val(meta), path("contig_to_taxid.tsv"), emit: converted_file

    script:
    
    """
    #!/bin/bash

    # Input and output files
    input_file="${diamond_file}"
    output_file="contig_to_taxid.tsv"

    # Initialize variables
    prev_test_id=""
    taxids=""

    # Read the input file line by line
    while read line; do
    # Extract the test ID (the part before the last underscore in the first column)
    test_id=\$(echo "\$line" | cut -f1 | sed 's/_[^_]*\$//')

    # Extract the TaxID using awk and grep for TaxID field
    taxid=\$(echo "\$line" | grep -o "TaxID=[0-9]*" | cut -d'=' -f2)

    # If we're still on the same test ID, append the TaxID
    if [[ \$test_id" == "\$prev_test_id" || "\$prev_test_id" == "" ]]; then
        if [[ "\$taxids" != "" ]]; then
        taxids="\$taxids,\$taxid"
        else
        taxids="\$taxid"
        fi
    else
        # If test ID changed, print the previous result and reset
        echo "\$prev_test_id   \$taxids" >> "\$output_file"
        taxids="\$taxid"
    fi

    prev_test_id="\$test_id"
    done < "\$input_file"

    # Print the last test ID and its TaxIDs
    echo "\$prev_test_id   \$taxids" >> "\$output_file"
    """
}

workflow TAXONOMY {
    take:
    proteins                    // [ val(meta), path(assembly_fasta) ]

    main:
    
    db = [[id: ""], params.taxonomy_db]
    DIAMOND_BLASTP(proteins, db, "txt", "qseqid salltitles")

    REFORMAT_DIAMOND_OUTPUT(DIAMOND_BLASTP.out.txt)

    TAXONKIT_LCA(REFORMAT_DIAMOND_OUTPUT.out.converted_file, 1, ",")

    emit:
    output = TAXONKIT_LCA.out.converted_file
}

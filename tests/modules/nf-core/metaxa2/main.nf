#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

include { METAXA2 } from '../../../../modules/nf-core/metaxa2/main.nf'

workflow test_metaxa2_general {
    
    input = [
        [ id:'test'], // meta map
            file("https://github.com/nf-core/test-datasets/tree/modules/data/genomics/prokaryotes/bacteroides_fragilis/illumina/fasta", checkIfExists: true)
        ]

    o = "test_general"
    pairfile = []

    METAXA2 ( input, o, pairfile )
}

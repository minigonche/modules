process METAXA2 {
    tag "$meta.id"
    label 'process_single'

   
    conda "bioconda::metaxa=2.2.3"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/metaxa:2.2.3--pl5321hdfd78af_1':
        'biocontainers/metaxa:2.2.3--pl5321hdfd78af_1' }"

    input:
    tuple val(meta), path(i)    
    val(o)
    path(pairfile)


    output:
    tuple val(meta), path("${o}.summary.txt"), emit: summary
    tuple val(meta), path("${o}.extraction.results"), optional:true, emit: extraction_results
    tuple val(meta), path("*.fasta"), optional:true, emit: fasta
    tuple val(meta), path("${o}.graph"), optional:true, emit: graphical
    tuple val(meta), path("${o}.*.table"), optional:true, emit: table
    tuple val(meta), path("${o}.taxonomy.txt"), optional:true, emit: taxonomy
    tuple val(meta), path("${o}._not_found.txt"), optional:true, emit: not_found
    path "versions.yml", emit: versions


    //when:
    //task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    def pair_command = pairfile ? "--pairfile ${pairfle} " : ""
    """
    metaxa2 -i ${i} -o ${o} ${pair_command} --cpu ${task.cpus} -f f $args
        
    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        metaxa2 : \$( metaxa2 --license 2>&1 | sed -n 's/Version: \\(.*\\)/\\1/p')
    END_VERSIONS
    """
}

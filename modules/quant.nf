
process QUANT {
    tag "$pair_id"

    input:
    path index 
    tuple val(pair_id), path(reads) 

    output:
    path pair_id 

    script:
    """
    salmon quant --threads $task.cpus --libType=U -i $index -1 ${reads[0]} -2 ${reads[1]} -o $pair_id
    """
}
rule fetch_mgy_clusters:
    output:
        flag="resources/{mgy_release}/mgy_clusters.flag",
    log:
        "logs/fetch_mgy_clusters/fetch_mgy_clusters_{mgy_release}.log",
    conda:
        "../envs/mgnify.yaml"
    params:
        ftp_url="http://ftp.ebi.ac.uk/pub/databases/metagenomics/peptide_database/{mgy_release}/mgy_clusters.fa.gz",
        mgy_clusters="resources/mgnify/{mgy_release}/mgy_clusters.fa.gz",
    shell:
        """
        parent_dir=$(dirname "{params.mgy_clusters}")
        mkdir -p $parent_dir
        wget -nc {params.ftp_url} -O {params.mgy_clusters} 2>> {log}
        gunzip -k {params.mgy_clusters} 2>> {log}
        echo "done" > {output.flag}
        """

rule fetch_mgy_clusters:
    output:
        clusters_faa="resources/mgnify/{mgy_release}/mgy_clusters.fa",
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
        if [ ! -f {params.mgy_clusters} ]; then
            wget -nc {params.ftp_url} -O {params.mgy_clusters} 2>> {log}
            gunzip -k {params.mgy_clusters} 2>> {log}
        fi
        """

rule fetch_mgy_assemblies:
    output:
        flag="resources/mgnify/{mgy_release}/mgy_assemblies.flag",
    log:
        "logs/fetch_mgy_assemblies/fetch_mgy_assemblies_{mgy_release}.log",
    conda:
        "../envs/mgnify.yaml"
    params:
        ftp_url="http://ftp.ebi.ac.uk/pub/databases/metagenomics/peptide_database/{mgy_release}/mgy_assemblies.tsv.gz",
        mgy_assemblies="resources/mgnify/{mgy_release}/mgy_assemblies.tsv.gz",
    shell:
        """
        parent_dir=$(dirname "{params.mgy_assemblies}")
        mkdir -p $parent_dir
        if [ ! -f {params.mgy_assemblies} ]; then
            wget -nc {params.ftp_url} -O {params.mgy_assemblies} 2>> {log}
            gunzip -k {params.mgy_assemblies} 2>> {log}
        fi
        echo "done" > {output.flag}
        """

rule phmmer_search:
    input:
        clusters_faa=rules.fetch_mgy_clusters.output.clusters_faa,
        query_faa=lambda wildcards: (input_path / df_samples.loc[wildcards.name, "path"]).resolve(),
    output:
        tbl="data/processed/{name}/{name}_vs_{mgy_release}_phmmer_search.tbl",
        aln="data/processed/{name}/{name}_vs_{mgy_release}_phmmer_search.aln",
    conda:
        "../envs/mgnify.yaml"
    log:
        "logs/phmmer_search/phmmer_search_{name}_{mgy_release}.log",
    params:
        E=1,
        domE=1,
        incE=0.01,
        incdomE=0.03,
        mx="BLOSUM62",
        pextend=0.4,
        popen=0.02,
    threads: 8
    shell:
        """
        phmmer -E {params.E} --domE {params.domE} --incE {params.incE} --incdomE {params.incdomE} --mx {params.mx} \
            --pextend {params.pextend} --popen {params.popen} --cpu {threads} \
            --tblout {output.tbl} -A {output.aln} \
            {input.query_faa} {input.clusters_faa} &>> {log}
        """

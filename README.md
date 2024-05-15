# mgnify_misc
This script give example to analyse the result from MGnify sequence search.
Inspired from:
- https://docs.mgnify.org/src/notebooks/Python%20Examples/Atlanteco%20Interactive%20Sample%20Map.html
- https://hackmd.io/@duc-nguyen/HyyDnbFuT?utm_source=preview-mode&utm_medium=rec

## Usage
### Making the search
1. Go to [https://www.ebi.ac.uk/metagenomics/sequence-search/search/phmmer](https://www.ebi.ac.uk/metagenomics/sequence-search/search/phmmer) and run your query
2. Donwload the `.JSON` formatted result and put it into the `data/raw` directory

### Processing the search result
1. Create conda env
```bash
mamba env create -f env.yaml
```

2. Start a jupyter session
```bash
conda activate <env>
jupyter lab --no-browser
```

3. Run the notebook in the `notebooks` folder

## Doing the search locally
Because of the size in the latest database release, it takes forever to run the search through the web portal.
To download the peptide database locally, run using snakemake:
```bash
snakemake --use-conda -c 2
```

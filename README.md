## ideel

This repo builds on [code](https://github.com/mw55309/ideel) by Mick Watson who wrote a [blog post](http://www.opiniomics.org/a-simple-test-for-uncorrected-insertions-and-deletions-indels-in-bacterial-genomes/) and [follow up](http://www.opiniomics.org/with-great-power-comes-great-responsibility/) about a quick way to test the viability of a (long-read) assembly.

### Dependencies:

- Snakemake
- Prodigal
- Diamond
- R (including libraries readr and ggplot2)

You will need a Diamond index like UniProt TREMBL.

### run

Clone the repo. 

The output of the workflow will be written to `--directory`. In there, make a directory called "genomes", put assemblies in there with .fa file extension

Edit the `config.json` file, specifying e.g. the path to the Diamond database.

Then:

```bash
# http://snakemake.readthedocs.io/en/stable/executable.html
# http://snakemake.readthedocs.io/en/stable/snakefiles/configuration.html
snakemake --configfile config.json --directory ~/tmp/ --cores 4
# per default, Snakemake uses only 1 CPU core
```



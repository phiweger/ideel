import sys
import os

thisdir = os.path.abspath(os.path.dirname(__file__))
print(thisdir)

shell.executable('/bin/bash')
t = config['threads']


IDS, = glob_wildcards('genomes/{id}.fa')

if len(IDS) == 0:
    print('No genomes found -- is the path in the config correct?')
    sys.exit(1)

rule all: 
    input: expand('hists/{sample}.pdf', sample=IDS)

    
rule prodigal:
    input: 'genomes/{id}.fa'
    output: 'proteins/{id}.faa'
    shell: 'prodigal -a {output} -q -i {input}'


rule diamond:
    input: 'proteins/{id}.faa'
    output: 'lengths/{id}.data'
    threads: t
    params:
        db = config['db'],
        of = '6 qlen slen'
    shell: 'diamond blastp --threads {threads} --max-target-seqs 1 --db {params.db} --query {input} --outfmt {params.of} --out {output}'    


rule hist:
    input: 'lengths/{id}.data'
    output: 'hists/{id}.pdf'
    script: 'scripts/hist.R'
    # http://snakemake.readthedocs.io/en/stable/snakefiles/rules.html#external-scripts

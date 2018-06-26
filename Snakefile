import sys
import os


shell.executable('/bin/bash')
t = config['threads']
print('Looking for database in:', config['db'])
print('Looking for genomes in:', os.getcwd() + 'genomes/')


IDS, = glob_wildcards('genomes/{id}.fa')

if len(IDS) == 0:
    print('No genomes found.') 
    print('Is the path to the genomes/file.fa correct?')
    print('Is the file extension .fa instead of .fasta?')
    sys.exit(1)


rule all: 
    input: expand('hists/{sample}.pdf', sample=IDS)

    
rule prodigal:
    input: 'genomes/{id}.fa'
    output: temp('proteins/{id}.faa')
    shell: 'prodigal -a {output} -q -i {input}'


rule diamond:
    input: 'proteins/{id}.faa'
    output: temp('lengths/{id}.data')
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

# Steps to Generate Input Files

This directory contains the scripts and job files used to generate the input files required by the R analysis workflow.

The scripts were originally executed on the **NYU Prince HPC cluster** using Unix command-line tools and **SLURM job scheduling**.  
Each numbered file in this directory corresponds to a step in the pipeline.

The Trinity transcriptome assemblies used in the analysis are included in this folder in **.zip** and **.7z** formats.

---

# Pipeline Overview

## 1. Download RNA-seq Reads and Quality Control

On a Unix system:

- Download raw RNA-seq reads from the **SRA database**
- Each sample consists of **paired-end reads**, split into two FASTQ files
- Run **FastQC** to evaluate read quality before downstream analysis

---

## 2. Transcriptome Assembly

Assemble transcriptomes using **Trinity** on an HPC system.

Trinity generates the assembled transcript FASTA files used in downstream expression quantification and functional annotation.

---

## 3. Gene Expression Quantification

Estimate transcript abundance using **kallisto** on the HPC cluster.

Kallisto produces abundance tables used later in the R analysis workflow.

---

## 4. Functional Annotation with InterProScan

### 4a. Prepare FASTA Files for Parallel Processing

Before running InterProScan:

- Trim the FASTA headers as required by the pipeline
- Split the Trinity FASTA file into **multiple smaller FASTA files**

Each split FASTA file contains **100 sequences** to enable parallel processing.

If lower parallelism is desired, increase the number of sequences per file.

---

### 4b. Run InterProScan in Parallel

Run **InterProScan** on the HPC cluster using parallel jobs.

Each job processes one of the split FASTA files and produces a **TSV annotation output**.

---

### 4c. Merge Annotation Output

After the parallel jobs complete:

- Navigate to the directory containing all InterProScan output files
- Merge the individual **TSV files** into a single annotation file

This merged file is used as the annotation input for the R workflow.

---

# Output

The pipeline produces the following key files used by the main analysis:

- **Transcript abundance tables** (kallisto output)
- **Functional annotation tables** (InterProScan output)

These files are described in the `Input files` directory.
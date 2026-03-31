<p align="center">
  <img src="../assets/cellular_automata_hex.svg" width="220">
</p>

# Output Files

This directory contains processed results from the analysis pipeline, organized by functional annotation source. Protein sequences derived from assembled scaffolds (transcripts) were translated in silico and annotated using InterProScan. Domain assignments were performed against the Pfam database, where protein families are modeled using profile hidden Markov models (HMMs) built from curated seed alignments and expanded with UniProtKB reference proteome sequences. Associated Gene Ontology (GO) terms were also retrieved through InterProScan.

---

## Directory Structure

- **go/**
  Gene Ontology–based results

- **pfam/**
  Protein family (Pfam)–based results

Each directory contains species-specific outputs and mappings between functional annotations, genes, and isoforms.

---

## Contents

Within both `go/` and `pfam/`, the following subdirectories are provided:

### 1. species-specific GO terms

- Contains text files for each species
- Each file lists functional terms identified as species-specific

These represent the highest-level functional annotations.

---

### 2. species-specific genes

- Maps species-specific functional terms to their originating genes
- Each entry links a functional annotation back to a gene-level identifier

---

### 3. species-specific isoforms

- Maps species-specific functional terms to specific transcript isoforms
- Provides the most granular level of resolution

---

## Data Relationships

The data are structured to preserve traceability across biological levels:

```
Functional term (GO / Pfam)
↓
Gene
↓
Isoform (transcript)
```

- Each functional term can be traced back to:
  - the originating gene
  - the specific isoform in which it was identified

This enables detailed downstream analysis at both the gene and transcript level.

---

## Notes

- File formats are plain text for portability and ease of parsing
- Naming conventions are consistent across GO and Pfam outputs
- These files are intended for downstream statistical analysis and visualization

---

## Usage

Typical use cases include:

- Identifying species-specific functional enrichment
- Linking functional annotations to gene-level variation
- Investigating isoform-specific functional patterns
- Integrating with visualization outputs in the `docs/visualizations/` folder
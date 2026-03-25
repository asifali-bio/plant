# Trinity Assembly

The raw RNA-seq reads were assembled *de novo* using **Trinity**, with a minimum contig length of **200 bp** across all species.

Trinity reconstructs transcriptomes through three key stages:

---

## 🐛 Inchworm
Inchworm assembles the RNA-seq reads into the dominant transcript sequences.
It greedily builds contigs while capturing signals of alternative splicing and transcript variation.

---

## 🌀 Chrysalis
Chrysalis clusters related contigs into components representing genes or gene families.
It then constructs a **de Bruijn graph** for each cluster, organizing isoforms and sequence complexity.

---

## 🦋 Butterfly
Butterfly processes each graph to resolve full-length transcripts.
It reconstructs isoforms by evaluating paths through the graph, accounting for:
- Alternative splicing
- Gene paralogs

---

Together, these steps enable Trinity to generate high-quality transcriptome assemblies without a reference genome.
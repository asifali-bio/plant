# Input Files

This directory contains the input files required to run the R workflow.

## Required Files

The analysis requires three types of input files:

1. **Abundance files**  
   Generated from **Kallisto output**

2. **Annotation files**  
   Generated from **InterProScan output**

3. **Species list file**  
   A CSV file listing the species included in the analysis

## File Naming Convention

Abundance and annotation files should be named using a **consistent numbering scheme** that corresponds to each species.

Example:

```
abundance1.tsv
annotation1.tsv
abundance2.tsv
annotation2.tsv
```

The numbering should match the order of species listed in the species list CSV file.

## Creating the Species List CSV

The species list file can be created using spreadsheet software such as **Microsoft Excel**:

1. Enter each species name in **Column A**, with **one species per row**
2. Do **not include a header**.
3. Ensure the order corresponds to the numbered abundance and annotation files
4. Export or save the file as **CSV format**

Example:

```
sapiens
neanderthalensis
erectus
```

## Running the R Code

1. Place all input files in the **same directory**.
2. In R, set the **working directory** to this location.
3. Run the R script **line by line**.
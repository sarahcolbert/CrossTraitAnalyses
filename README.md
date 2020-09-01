# Implementing Cross-Trait Genetic Analyses at Multiple Scales using GWAS Summary Statistics



This github repository outlines the framework used in [Colbert et al. 2020](https://www.medrxiv.org/content/10.1101/2020.08.21.20179374v1) to assess multi-scale genetic relationships between comorbid disorders using GWAS summary statistics. 

Say you have five traits (A, B, C, D, E) for which you would like to assess the genetic relationships between and their corresponding summary statistics. You can do so using this framework.

### Part 1A: Preformatting summary statistics

First, create a directory which will hold the original summary statistics and navigate to this directory:

```
mkdir og_sumstats
cd og_sumstats
```

Then download the summary statistics you would like to use:

```
wget https://exampledownload.com
```

In order to perform the subsequent analyses, you must first check your downloaded summary statistics for a few requirements.

* What is the format of the SNP column?
  * If there are SNPs not in the forms rsID or chr:bp:A1:A2 then you will need to reformat the SNP column. [code.md]() provides code for multiple misspecified SNP column scenarios.
* Is the following information easily identified in the summary statistics files or accompanying README file?
  * SNPs
  * Effect allele/reference allele (this may be labeled as A1, A2, REF, etc. so users should be careful to correctly identify this column)
  * Non-effect allele
  * Sample size (sample size may be identified for each SNP, or it is also okay to use the sample size identified by the original authors)
  * P-value
  * A signed summary statistic 

Create a new directory to hold all summary statistics which are in the proper format and move the reformatted summary statistics into this directory:

```
mkdir sumstats
mv reformatted_sumstats.txt.gz ./sumstats/
```

### Part 1B: Preparing summary statistics

Most softwares we will be using require the summary statistics to be formatted using LDSC's munge function. Code describing how to munge the summary statistics can be found on the [LDSC github](https://github.com/bulik/ldsc/wiki/Heritability-and-Genetic-Correlation). 
It is best to use the --merge-alleles argument to filter to HapMap3 SNPs.

Create a new directory to place all munged summary statistics:

```
mkdir munged_sumstats
```

### Part 2A: Calculating Genome-Wide Genetic Correlation

We used [LDSC](https://github.com/bulik/ldsc/wiki/Heritability-and-Genetic-Correlation) to calculate genome-wide genetic correlations. Pairwise genetic correlations amongst all traits can be easily done at once using a job array, for example, like [this](pair-rgs.bash). 

### Part 2B: Aggregating results and Visualizing

Once all results files are saved in the format Trait1_Trait2_rg.log and in the same directory, you can combine them into one large table using some [basic command line code](https://github.com/sarahcolbert/CrossTraitAnalyses/blob/master/make_rg_table.md).

You may also wish to have results displayed in a correlation matrix table, which can be created in R using the script [rg_fdr_matrices.R](https://github.com/sarahcolbert/CrossTraitAnalyses/blob/master/rg_fdr_matrices.R). 

These matrices can also be used to make heat maps in R, which is demonstrated in [rg_heatmap.R](https://github.com/sarahcolbert/CrossTraitAnalyses/blob/master/rg_heatmap.R). 

### Part 3: Calculate genetic covariance in specific functional annotations

GNOVA is not compatible with summary statistics with missing data, so we had to remove all NA values, which was done easily in R using the script [remove-NAs.R](https://github.com/sarahcolbert/CrossTraitAnalyses/blob/master/remove-NAs.R). 

After removings NAs and creating new summary statistics located in /gnova_sumstats/, we were able to use [GNOVA]() to calculate annotation specific genetic covariances.









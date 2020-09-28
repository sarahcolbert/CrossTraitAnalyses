# Implementing Cross-Trait Genetic Analyses at Multiple Scales using GWAS Summary Statistics


This github repository outlines the framework used in [Colbert et al. 2020](https://www.medrxiv.org/content/10.1101/2020.08.21.20179374v1) to assess multi-scale genetic relationships between comorbid disorders using GWAS summary statistics. 

Say you have five traits (A, B, C, D, E) for which you would like to assess the genetic relationships between. You can do so using this framework if you have the summary statistics for these traits.

### Part 1A: Preformatting summary statistics

First, create a directory which will hold the original summary statistics. Navigate to this directory and download the summary statistics you would like to use.

```
mkdir og_sumstats
cd og_sumstats
wget www.example.edu/files/traitA.gz
wget www.example.edu/files/traitB.gz
wget www.example.edu/files/traitC.gz
wget www.example.edu/files/traitD.gz
wget www.example.edu/files/traitE.gz
```

Now that you have the summary statistics, you must check to make sure that they contain all the necessary information and are formatted correctly. Here are some things to consider:

* What is the format of the SNP column?
  * Ideally, SNPs will be identified either by rsID or in the chr:bp:A1:A2 format. If they are not, then you will need to reformat the SNP column. [code.md]() provides code for reformatting multiple misspecified SNP column scenarios.
* Is the following information easily identified in the summary statistics files or accompanying README file?
  * SNPs
  * Effect allele/reference allele (this may be labeled as A1, A2, REF, etc. so users should be careful to correctly identify this column)
  * Non-effect allele
  * Sample size (sample size may be identified for each SNP but it is also okay to use the sample size for the study)
  * P-value
  * A signed summary statistic 

Create a new directory to hold all summary statistics which are in the proper format. This could be the original files or maybe new files if the SNP column was formatted weird or you wanted to change the allele names to make them easier to keep track of.

```
mkdir sumstats
mv reformatted_sumstats.gz ./sumstats/
```

### Part 1B: Preparing summary statistics

Most softwares used require the summary statistics to be formatted using LDSC's munge function. Code describing how to munge the summary statistics can be found on the [LDSC github](https://github.com/bulik/ldsc/wiki/Heritability-and-Genetic-Correlation). 

Create a new directory to place all munged summary statistics. The files in this directory will be the files primarily used in subsequent analyses. 

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

After removings NAs and creating new summary statistics located in /gnova_sumstats/, we were able to use [GNOVA](https://github.com/xtonyjiang/GNOVA) to calculate annotation specific genetic covariances.

### Part 4: Calculate local genetic covariances

We used SUPERGNOVA and the NA removed sumstats to calculate local genetic covariance estimates. Results files were place in a directory corresponding to the first trait and a file name corresponding to the second trait. We provide a [function and script for plotting these results](https://github.com/sarahcolbert/CrossTraitAnalyses/blob/master/supergnova_plots.R) in R. 



# Using the command line to create a table with all genetic correlation results


### Step 1: pull header line from an example file and create new header file

```
grep "^p1" /rg_results/A_B_rg.log > /rg_results/header.txt
```

### Step 2: for every file in the directory that ends with ".log", pull any line starting with the summary statistics file path and then put that line into the results file

We do this because lines starting with the sumstats file path contain the results

```
grep -h ^/munged_sumstats/ /rg_results/*.log >> /rg_results/rg_table1.txt
```

### Step 3: To get just the phenotype label, remove the strings that come before and after it in the file path

```
sed -i 's@/munged_sumstats/@@g' /rg_results/rg_table1.txt
sed -i 's@.sumstats.gz@@g' /rg_results/rg_table1.txt
```

### Step 4: Sort the file so that the first column places the traits in descending order by number of occurrences

```
awk  'NR==FNR{a[$1]++;next}{ print a[$1],$0}' /rg_results/rg_table1.txt /rg_results/rg_table1.txt|sort -nr|sed -r 's/[0-9]* //' > /rg_results/rg_table2.txt
```

### Step 5: Add header to top of file

```
cat /rg_results/header.txt /rg_results/rg_table2.txt > rg_table.txt
```

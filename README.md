# cff-validator

![latest-version](https://img.shields.io/github/v/release/dieghernan/cff-validator)
[![CITATION-cff](https://github.com/dieghernan/cff-validator/actions/workflows/cff-validator.yml/badge.svg)](https://github.com/dieghernan/cff-validator/actions/workflows/cff-validator.yml)

A GitHub action to validate CITATION.cff
files with R.

## Introduction


If you have a [Citation File Format
(cff)](https://citation-file-format.github.io) on your repository this action would check its validity against the defined [schema](https://github.com/citation-file-format/citation-file-format/blob/main/schema-guide.md). 

A full valid workflow:

```yaml
on:
  push:
    branches: [main, master]
  pull_request:
    branches: [main, master]

name: CITATION-cff
jobs:
  Validate-CITATION-cff:
    runs-on: ubuntu-latest
    name: Validate CITATION.cff
    env:
      GITHUB_PAT: ${{ secrets.GITHUB_TOKEN }}
      RSPM: "https://packagemanager.rstudio.com/cran/__linux__/focal/latest"
      
    steps:
      - name: Checkout
        uses: actions/checkout@v2
        
      # This is needed for workflows running on
      # ubuntu-20.04 or later
      - name: Install V8 
        if: runner.os == 'Linux'
        run: |
          sudo apt-get install -y libv8-dev

      - name: Validate CITATION.cff
        uses: dieghernan/cff-validator@main

```

On error, the action shows the results of the validation highlighting the fields with errors.

For more examples, see the actions provided on [this path](https://github.com/dieghernan/cff-validator/tree/main/.github/workflows).

## Inputs available

- `citation-path`: Path to .cff file to be validated. By default it selects a CITATION.cff file on the root of the repository:

```yaml
  - name: Validate CITATION.cff
    uses: dieghernan/cff-validator@main
    with:
      citation-path: "example/CITATION.cff"

```

## Building on Linux

This action relies on the R package `V8`, that has some extra requirements when running on Linux systems. You would need to add the following steps to your action in order to make it run:

```yaml
      # This is needed for workflows running on
      # ubuntu-20.04 or later
      - name: Install V8 
        run: |
          sudo apt-get install -y libv8-dev
          
      # This is needed for workflows running on
      # previous versions of ubuntu
      - name: Install V8 on old ubuntu
        run: |
          # Ubuntu Xenial (16.04) and Bionic (18.04) only
          sudo add-apt-repository ppa:cran/v8
          sudo apt-get update
          sudo apt-get install libnode-dev

``` 

See a full featured implementation on [this example](https://github.com/dieghernan/cff-validator/blob/main/.github/workflows/cff-validator-full-matrix.yml).


## Under the hood (for useRs)

This action runs a R script that can be easily replicated. See a full reprex:

```r

# Libraries
install.packages(c("yaml","jsonlite", "jsonvalidate"))

citation_cff_path <- "CITATION.cff"

citfile <- yaml::read_yaml(citation_cff_path)
          
cit_temp <- tempfile(fileext = ".json")

# Convert to json
jsonlite::write_json(citfile, 
                     cit_temp, 
                     pretty = TRUE)
          
# Clean json file
citfile_clean <- readLines(cit_temp)
citfile_clean <- gsub('["','"',citfile_clean, fixed = TRUE)
citfile_clean <- gsub('"]','"', citfile_clean, fixed = TRUE)

writeLines(citfile_clean, cit_temp)
          
# Download latest scheme
schema_temp <- tempfile("schema", fileext = ".json")

download.file("https://raw.githubusercontent.com/citation-file-format/citation-file-format/main/schema.json",
          schema_temp, mode="wb", quiet = TRUE)
          
result <- jsonvalidate::json_validate(cit_temp,
                            schema_temp,
                            verbose = TRUE)

if (result == FALSE){
  print(attributes(result)$errors)
  message("\n")
  stop(citation_cff_path, " file no valid")
} else {
  message(citation_cff_path, " is valid")
}


```

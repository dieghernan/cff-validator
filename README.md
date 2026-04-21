# cff-validator

![latest-version](https://img.shields.io/github/v/release/dieghernan/cff-validator)
[![CITATION-cff](https://github.com/dieghernan/cff-validator/actions/workflows/cff-validator.yml/badge.svg)](https://github.com/dieghernan/cff-validator/actions/workflows/cff-validator.yml)
[![full-test-action](https://github.com/dieghernan/cff-validator/actions/workflows/cff-validator-complete-matrix.yml/badge.svg)](https://github.com/dieghernan/cff-validator/actions/workflows/cff-validator-complete-matrix.yml)
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.5348443.svg)](https://doi.org/10.5281/zenodo.5348443)

A GitHub action to validate `CITATION.cff` files with R.

**Breaking change: v4 only works on Linux, upgrade your v3 to run on
`ubuntu-*`.**

## Introduction

If you have a [Citation File Format
(cff)](https://citation-file-format.github.io) on your repository this action
would check its validity against the defined
[schema](https://github.com/citation-file-format/citation-file-format/blob/main/schema-guide.md).

A full valid workflow:

``` yaml
on:
  push:
    paths:
      - CITATION.cff
  workflow_dispatch:

name: CITATION.cff
jobs:
  Validate-CITATION-cff:
    runs-on: ubuntu-latest
    name: Validate CITATION.cff
    env:
      GITHUB_PAT: ${{ secrets.GITHUB_TOKEN }}

    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Validate CITATION.cff
        uses: dieghernan/cff-validator@v4
```

On error, the action produces a Job Summary with a high-level description of the
errors found:

<details>

<summary><strong>citation_cff.md</strong></summary>

❌ CITATION.cff has errors

| field           | message                          |
|:----------------|:---------------------------------|
| data            | has additional properties        |
| data.authors.0  | no schemas match                 |
| data.doi        | referenced schema does not match |
| data.keywords.0 | is the wrong type                |
| data.license    | referenced schema does not match |
| data.url        | referenced schema does not match |

: See [Guide to Citation File Format schema version
1.2.0](https://github.com/citation-file-format/citation-file-format/blob/main/schema-guide.md)
for debugging.

</details>

For more examples, see the actions provided on [this
path](https://github.com/dieghernan/cff-validator/tree/main/.github/workflows).

## Add a badge to your repo

You can easily create a badge showing the current status of validation of your
`CITATION.cff` by adding this snippet to your repository's `README.md`:

```markdown
[![CITATION-cff](https://github.com/dieghernan/cff-validator/actions/workflows/cff-validator.yml/badge.svg)](https://github.com/dieghernan/cff-validator/actions/workflows/cff-validator.yml)
```

which will then display:

[![CITATION.cff](https://github.com/dieghernan/cff-validator/actions/workflows/cff-validator.yml/badge.svg)](https://github.com/dieghernan/cff-validator/actions/workflows/cff-validator.yml)

[![CITATION-cff
error](https://github.com/dieghernan/cff-validator/actions/workflows/cff-validator-error.yml/badge.svg)](https://github.com/dieghernan/cff-validator/actions/workflows/cff-validator-error.yml)

See a quick demo:

![Demo gif showing how to create a badge for a GH action](assets/demo.gif)

## Inputs available

-   `citation-path`: Path to .cff file to be validated. By default it selects a
    `CITATION.cff` file on the root of the repository:

``` yaml
  - name: Validate CITATION.cff
    uses: dieghernan/cff-validator@v4
    with:
      citation-path: "examples/CITATION.cff"
```

-   (Soft) Deprecated parameters in **v4**:

    -   `cache-version`

    -   `install-r`.

See a full featured implementation on [this
example](https://github.com/dieghernan/cff-validator/blob/main/.github/workflows/cff-validator-complete-matrix.yml).

## For useRs

This action runs on R. For the same functionality you can use the **cffr**
package:

``` r

cffr::cff_validate("CITATION.cff")
#> 
#> cff_validate results——
#> Congratulations! This .cff file is valid
```

See
[`cffr::cff_validate()`](https://docs.ropensci.org/cffr/reference/cff_validate.html)
for details.

## References

Druskat, S., Spaaks, J. H., Chue Hong, N., Haines, R., Baker, J., Bliven, S.,
Willighagen, E., Pérez-Suárez, D., & Konovalov, A. (2021). Citation File Format
(Version 1.2.0) [Computer software]. <https://doi.org/10.5281/zenodo.5171937>

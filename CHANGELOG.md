# v4

Note that `v4` is a sliding tag, and we introduce non-breaking changes to it.

**Breaking change**: The action now uses a Docker container, and would require
to be run on a Linux virtual machine (`os: ubuntu-*`). MacOS and Windows actions
would need to switch to `ubuntu-*`.

-   Migration to Docker container
    [**rocker/tidyverse**](https://hub.docker.com/r/rocker/tidyverse/).

# v3

Note that `v3` is a sliding tag, and we introduce non-breaking changes to it.

-   Improve underlying code.
-   Using a copy of schema.json shipped with {cffr} to avoid SSL/SSH issues
    [#10](https://github.com/dieghernan/cff-validator/issues/10).
-   Update versions of depencies
    ([#13](https://github.com/dieghernan/cff-validator/pull/13),
    [#14](https://github.com/dieghernan/cff-validator/pull/14))

## v3.0.1 (2023-07-21)

-   Improve underlying code.
-   Using a copy of schema.json shipped with {cffr} to avoid SSL/SSH issues
    [#10](https://github.com/dieghernan/cff-validator/issues/10)

## v3.0.2 (2024-02-08)

-   Update versions of dependencies
    (<https://github.com/dieghernan/cff-validator/pull/13>,
    [#14](https://github.com/dieghernan/cff-validator/pull/14))

## v3.0.3 (2025-01-17)

-   Always install R (#16) hence (soft) deprecation of `install-r` parameter.
-   Update versions of dependencies.

# v2.3

-   Fix [#8](https://github.com/dieghernan/cff-validator/issues/8), error on
    non-Git repos.

# v2.2

-   New `install-r` parameter.
-   Improvements on performance.

# v2.1

-   New `cache-version` parameter.
-   Better handling of R packages via `pak` R package.
-   Improve cache of packages.

# v2

-   Pretty printing of errors.
-   On errors, the action uploads an artifact.
-   Fix typos thanks to @sdruskat.
-   Update file examples.
-   Add `r-reprex.R` with a full working **R** workflow.
-   Fix errors due to changes on dependencies.

# v1

-   First stable release

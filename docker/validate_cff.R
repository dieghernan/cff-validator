# Modified version from pharmaverse/admiralci
# See https://github.com/pharmaverse/admiralci/tree/61347fe11955297818b3ca7814fc7328f2ad7840/.github/actions/cran-status-extract


# 0. Setup ----
if (!requireNamespace("cffr", quietly = TRUE)) {
  suppressMessages(install.packages("cffr",
    repos = "https://cloud.r-project.org",
    verbose = FALSE,
    quiet = TRUE,
    dependencies = TRUE
  ))
}
if (!requireNamespace("optparse", quietly = TRUE)) {
  suppressMessages(install.packages("optparse",
                                    repos = "https://cloud.r-project.org",
                                    verbose = FALSE,
                                    quiet = TRUE
  ))
}

# check if needed : package name and working dir path as input arguments :
library(optparse)
option_list <- list(
  make_option(c("-p", "--cffpath"),
              type = "character",
              help = "package name (REQUIRED)",
              metavar = "character"
  )
)
opt_parser <- OptionParser(option_list = option_list)
opt <- parse_args(opt_parser)




# Validate cff ----
cffpath <- opt$cffpath

cat("Validating cff\n")
citfile <- yaml::read_yaml(cffpath)
# All elements to character
citfile <- rapply(citfile, function(x) as.character(x), how = "replace")

# Convert to json
cit_temp <- jsonlite::toJSON(citfile, pretty = TRUE, auto_unbox = TRUE)

# Use local copy of schema, included with cffr
schema_local <- system.file("schema/schema.json", package = "cffr")

# Validate
result <- jsonvalidate::json_validate(cit_temp,
                                      schema_local,
                                      verbose = TRUE
)

# Results
if (result == FALSE) {
  writeLines(paste0("\n:x: ${{ inputs.citation-path }} has errors"),
             con = "citation_cff_errors.md"
  )
  # Format outputs
  get_errors <- attr(result, "errors")
  get_errors$field <- gsub(
    "^data", "cff",
    get_errors$field
  )

  write(knitr::kable(get_errors, align = "l"),
        file = "citation_cff_errors.md",
        append = TRUE
  )

  write("\n\nSee [Guide to Citation File Format schema version 1.2.0](https://github.com/citation-file-format/citation-file-format/blob/main/schema-guide.md) for debugging.",
        file = "citation_cff_errors.md",
        append = TRUE
  )
  stop("${{ inputs.citation-path }} file not valid. See Job Summary.")
} else {
  writeLines(paste0(
    ":white_check_mark: Congratulations! ${{ inputs.citation-path }} is valid"
  ),
  con = "citation_cff_ok.md"
  )
}

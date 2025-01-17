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
cffpath <- opt$cffpath


# clean files
if (file.exists("citation_cff.md")) unlink("citation_cff.md")
if (file.exists("issue.md")) unlink("issue.md")


# Validate cff ----


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
  writeLines(paste0("\n:x: ", cffpath, " has errors\n"),
    con = "citation_cff.md"
  )
  # Format outputs
  get_errors <- attr(result, "errors")
  get_errors$field <- gsub(
    "^data", "cff",
    get_errors$field
  )

  write(knitr::kable(get_errors, align = "l"),
    file = "citation_cff.md",
    append = TRUE
  )

  write("\n\nSee [Guide to Citation File Format schema version 1.2.0](https://github.com/citation-file-format/citation-file-format/blob/main/schema-guide.md) for debugging.",
    file = "citation_cff.md",
    append = TRUE
  )

  cat(paste0(
    "::warning::", cffpath,
    " has errors, see Job Summary of this GH action for details.\n"
  ))


  cat(paste0(cffpath, " file not valid. See Job Summary."))

  write("ERROR", file = "issue.md")
} else {
  writeLines(
    paste0(
      "\n:white_check_mark: Congratulations! ", cffpath, " is valid\n"
    ),
    con = "citation_cff.md"
  )
  cat(paste0(
    "::notice ::", cffpath,
    " is a valid CFF file.\n"
  ))
}

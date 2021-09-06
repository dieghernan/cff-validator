citation_path <- ".examples/key-error/CITATION.cff"

citfile <- yaml::read_yaml(citation_path)
# All elements to character
citfile <- rapply(citfile, function(x) as.character(x), how = "replace")

# Convert to json
cit_temp <- tempfile(fileext = ".json")
jsonlite::write_json(citfile, cit_temp, pretty = TRUE)

# Manage brackets
citfile_clean <- readLines(cit_temp)

# Search brackets to keep
# Keep ending and starting
keep_lines <- grep('", "', citfile_clean)
keep_lines <- c(keep_lines, grep("\\[$", citfile_clean))
keep_lines <- c(keep_lines, grep(" \\],", citfile_clean))
keep_lines <- c(keep_lines, grep(" \\]$", citfile_clean))
keep_lines <- sort(unique(keep_lines))

if (all(keep_lines > 0)) {
  keep_string <- citfile_clean[keep_lines]
  citfile_clean[keep_lines] <- ""
}
# Remove rest of brackets
citfile_clean <- gsub('["', '"', citfile_clean, fixed = TRUE)
citfile_clean <- gsub('"]', '"', citfile_clean, fixed = TRUE)

if (all(keep_lines > 0)) {
  # Add "good" brackets back
  citfile_clean[keep_lines] <- keep_string
}

writeLines(citfile_clean, cit_temp)

# Download latest scheme
schema_temp <- tempfile("schema", fileext = ".json")
download.file("https://raw.githubusercontent.com/citation-file-format/citation-file-format/main/schema.json",
  schema_temp,
  mode = "wb", quiet = TRUE
)

# Validate
result <- jsonvalidate::json_validate(cit_temp,
  schema_temp,
  verbose = TRUE
)
# Results
message("------\n")
if (result == FALSE) {
  print(knitr::kable(attributes(result)$errors,
    align = "l",
    caption = paste(citation_path, "errors:")
  ))

  message("\n\n------")
  stop(citation_path, "file not valid. See Artifact: citation-cff-errors for details.")
} else {
  message(citation_path, "is valid.")
  message("\n\n------")
}

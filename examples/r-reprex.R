citation_path <- "./examples/key-complete/CITATION.cff"

citfile <- yaml::read_yaml(citation_path)
# All elements to character
citfile <- rapply(citfile, function(x) as.character(x), how = "replace")

# Convert to json
cit_temp <- jsonlite::toJSON(citfile, pretty = TRUE, auto_unbox = TRUE)

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
  stop(citation_path, " file not valid. See Artifact: citation-cff-errors for details.")
} else {
  message(citation_path, " is valid.")
  message("\n\n------")
}

FROM rocker/tidyverse:4.6.1

WORKDIR /app

# Keep this in sync with the root Dockerfile. This action is retained for users
# who call the docker/ subaction directly.
RUN Rscript -e "options(repos = c(CRAN = 'https://cloud.r-project.org')); install.packages('pak'); pak::pak(c('cffr', 'jsonvalidate', 'optparse'), dependencies = TRUE, ask = FALSE)"

# Copy scripts
COPY validate_cff.R entrypoint.sh /app/

# Make the scripts executable
RUN chmod +x /app/*

# Set entrypoint
ENTRYPOINT ["/app/entrypoint.sh"]

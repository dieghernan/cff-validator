FROM rocker/tidyverse:4.6.1

WORKDIR /app

# Keep this in sync with docker/Dockerfile. The docker/ action is retained for
# users who call the subaction directly.
RUN Rscript -e "options(repos = c(CRAN = 'https://cloud.r-project.org')); install.packages('pak'); pak::pak(c('cffr', 'jsonvalidate', 'optparse'), dependencies = TRUE, ask = FALSE)"

COPY docker/validate_cff.R docker/entrypoint.sh /app/

RUN chmod +x /app/*

ENTRYPOINT ["/app/entrypoint.sh"]

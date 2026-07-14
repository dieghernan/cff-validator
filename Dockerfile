FROM rocker/tidyverse:4.6.1

WORKDIR /app

# Keep this in sync with docker/Dockerfile. The docker/ action is retained for
# users who call the subaction directly.
COPY docker/validate_cff.R docker/entrypoint.sh /app/

RUN chmod +x /app/*

ENTRYPOINT ["/app/entrypoint.sh"]

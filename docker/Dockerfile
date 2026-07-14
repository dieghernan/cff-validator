FROM rocker/tidyverse:4.6.1

WORKDIR /app

# Keep this in sync with the root Dockerfile. This action is retained for users
# who call the docker/ subaction directly.
# Copy scripts
COPY validate_cff.R entrypoint.sh /app/

# Make the scripts executable
RUN chmod +x /app/*

# Set entrypoint
ENTRYPOINT ["/app/entrypoint.sh"]

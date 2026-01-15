FROM rocker/tidyverse:4.5.2

WORKDIR /app

# Copy scripts
COPY validate_cff.R entrypoint.sh /app/

# Make the scripts executable
RUN chmod +x /app/*

# Set entrypoint
ENTRYPOINT ["/app/entrypoint.sh"]

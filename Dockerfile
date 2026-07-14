FROM rocker/tidyverse:4.6.1

WORKDIR /app

COPY docker/validate_cff.R docker/entrypoint.sh /app/

RUN chmod +x /app/*

ENTRYPOINT ["/app/entrypoint.sh"]

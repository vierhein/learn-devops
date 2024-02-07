# Use the nginx base image
FROM nginx:latest

COPY print_env.sh /docker-entrypoint.d/print_env.sh
RUN chmod +x /docker-entrypoint.d/print_env.sh
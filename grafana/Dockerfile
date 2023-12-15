FROM grafana/grafana:10.2.0

# Switch to root for installations
USER root

WORKDIR /usr/share/grafana

# Install AWS CLI for handling backups to S3
RUN apk update && \
    apk add --no-cache aws-cli && \
    rm -rf /var/cache/apk/*

# Copy necessary scripts and configuration files
COPY /scripts/* ./scripts/
COPY run.sh .
COPY grafana.ini /etc/grafana/grafana.ini

# Give Grafana user some priveledge to
# access to execute/read scripts dir
# and read/write to the scripts/data dir
RUN chown -R grafana ./scripts/ && \
    chown -R grafana /run.sh && \
    chmod 500 ./scripts/* /run.sh
    
RUN mkdir -p ./scripts/data && \
    chown -R grafana ./scripts/data && \
    chmod 755 ./scripts/data

# Switch back to the grafana user for security purposes
USER grafana

# If you have any Grafana plugins to install, uncomment and list them here
# RUN grafana-cli plugins install <plugin-name>

# Environment variables for configuration
# It's recommended to use a secret management tool for sensitive data
# ENV GF_SECURITY_ADMIN_USER=admin
# ENV GF_SECURITY_ADMIN_PASSWORD=secret

# Expose the Grafana default port
EXPOSE 3000

# Command to run restore script on start and then start Grafana
ENTRYPOINT ["/usr/share/grafana/run.sh"]

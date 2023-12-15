# Use an official Prometheus image as a parent image
FROM prom/prometheus:v2.47.2

# Set the working directory in the container
WORKDIR /etc/prometheus

# Copy the Prometheus configuration file into the container
COPY prometheus.yml /etc/prometheus/prometheus.yml

# Copy the Web configuration file into the container
COPY web.yml /etc/prometheus/web.yml

# Expose the default Prometheus port
EXPOSE 9090

CMD ["--config.file=/etc/prometheus/prometheus.yml", \
     "--storage.tsdb.path=/prometheus", \
     "--web.console.libraries=/usr/share/prometheus/console_libraries", \
     "--web.console.templates=/usr/share/prometheus/consoles", \
     "--web.config.file=/etc/prometheus/web.yml", \
     "--storage.tsdb.retention.time=60d"]
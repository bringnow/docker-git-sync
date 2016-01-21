FROM ubuntu:15.10
MAINTAINER Fabian Köster <fabian.koester@bringnow.com>

# Install runtime dependencies
RUN export DEBIAN_FRONTEND=noninteractive && apt-get update -qq && apt-get install -qq -y --no-install-recommends git openssh-client

# Add crontab file in the cron directory
COPY crontab /etc/cron.d/git-sync

# Fix permissions of crontab file
RUN chmod 644 /etc/cron.d/git-sync

# Install scripts
COPY sync.sh entrypoint.sh /usr/local/bin/

VOLUME /root/.ssh

# Run the command on container startup
ENTRYPOINT ["entrypoint.sh"]

#! /bin/bash

touch /var/log/cron.log

function die {
    echo >&2 "$@"
    exit 1
}

# Check mandatory environment variables
if [ -z "${GIT_USER_NAME}" ]; then
  die "GIT_USER_NAME must be specified!"
fi
if [ -z "${GIT_USER_EMAIL}" ]; then
  die "GIT_USER_EMAIL must be specified!"
fi
if [ -z "${GIT_REPO_URL}" ]; then
  die "GIT_REPO_URL must be specified!"
fi

# Ensure correct permissions
chmod 0700 /root/.ssh
chmod 0600 /root/.ssh/id_rsa
chmod 0644 /root/.ssh/id_rsa.pub
chmod 0644 /root/.ssh/known_hosts

# branch default
GIT_REPO_BRANCH=${GIT_REPO_BRANCH:=master}

# Set git author info
git config --global user.name "${GIT_USER_NAME}"
git config --global user.email "${GIT_USER_EMAIL}"

# Use default push behavior of Git 2.0
git config --global push.default simple

echo "GIT_USER_NAME=${GIT_USER_NAME}" >> /etc/sync_env
echo "GIT_USER_EMAIL=${GIT_USER_EMAIL}" >> /etc/sync_env
echo "GIT_REPO_URL=${GIT_REPO_URL}" >> /etc/sync_env
echo "GIT_REPO_BRANCH=${GIT_REPO_BRANCH}" >> /etc/sync_env

# CRON_TIME can be set via environment
# If not defined, the default is every minute
CRON_TIME=${CRON_TIME:-*/1 * * * *}
echo "Using cron time ${CRON_TIME}"
echo "@reboot root /usr/local/bin/sync.sh >> /var/log/cron.log 2>&1" > /etc/cron.d/git-sync
echo "${CRON_TIME} root /usr/local/bin/sync.sh >> /var/log/cron.log 2>&1" >> /etc/cron.d/git-sync
chmod 644 /etc/cron.d/git-sync

if [ "$1" = "--overwrite-local"  ]; then
  echo OVERWRITE_LOCAL="true" >> /etc/sync_env
fi

cron && tail -f /var/log/cron.log

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
chmod 0700 /root/.ssh && chmod 0600 /root/.ssh/id_rsa && chmod 0644 /root/.ssh/id_rsa && chmod 0644 /root/.ssh/known_hosts

# Set git author info
git config --global user.name "${GIT_USER_NAME}"
git config --global user.email "${GIT_USER_EMAIL}"

# Use default push behavior of Git 2.0
git config --global push.default simple

echo "GIT_USER_NAME=\"${GIT_REPO_URL}\"" >> /etc/sync_env
echo "GIT_USER_EMAIL=\"${GIT_REPO_URL}\"" >> /etc/sync_env
echo "GIT_REPO_URL=\"${GIT_REPO_URL}\"" >> /etc/sync_env

if [ "$1" = "--overwrite-local"  ]; then
  echo OVERWRITE_LOCAL="true" >> /etc/sync_env
fi

cron && tail -f /var/log/cron.log

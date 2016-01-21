#! /bin/bash

touch /var/log/cron.log
touch /etc/sync_env

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

# Set git author info
git config --global user.email "${GIT_USER_EMAIL}"
git config --global user.name "${GIT_USER_NAME}"

if [ "$1" = "--overwrite-local"  ]; then
  echo OVERWRITE_LOCAL="true" >> /etc/sync_env
fi

cron && tail -f /var/log/cron.log

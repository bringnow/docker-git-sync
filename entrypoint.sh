#! /bin/bash

touch /var/log/cron.log
touch /etc/sync_env

# Set git author info and git behavior
git config --global user.email "${GIT_USER_EMAIL}"
git config --global user.name "${GIT_USER_NAME}"
git config --global push.default simple

if [ "$1" = "--overwrite-local"  ]; then
  echo OVERWRITE_LOCAL="true" >> /etc/sync_env
fi

cron && tail -f /var/log/cron.log

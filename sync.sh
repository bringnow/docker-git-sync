#! /bin/bash

source /etc/sync_env

SYNC_DIR="/sync-dir"

function die {
    echo >&2 "$@"
    exit 1
}

if [ ! -d "$SYNC_DIR" ]; then
  echo "${SYNC_DIR} does not exist or is not a directory. Performing initial clone."
  git clone "${GIT_REPO_URL}" "${SYNC_DIR}" || die "git clone failed"
elif [ ! -d "$SYNC_DIR/.git" ]; then
  echo "${SYNC_DIR} exists but does not contain a git repository. Initializing local git repository before pulling remote"
  cd "${SYNC_DIR}"

  if [ "${OVERWRITE_LOCAL}" = "true"  ]; then
    echo "Removing all existing files in that directory beforehand as requested using --overwrite-local."
    find -delete
  fi

  if [ -n "$(ls -A ${SYNC_DIR})" ]; then
    die "${SYNC_DIR} is not empty and --overwrite-local was not specified"
  fi

  git init || die "git init failed"
  git remote add origin "${GIT_REPO_URL}" || die "git remote add failed"
  git fetch origin || die "git fetch failed"
  git checkout -t origin/master || die "git checkout failed"
fi

cd "${SYNC_DIR}"

git pull || die "git pull failed"

git add --all . || die "git add failed"

git diff-index --quiet HEAD

CHANGES_CODE=$?

if [ ${CHANGES_CODE} -ne 0 ]
then
  echo "Unsynced changes detected. Performing git commit and push."
  git commit -a -m "Sync" || die "git commit failed"
else
  echo "No changes to commit."
fi

CHANGES_TO_PUSH=$(git diff --stat --cached origin/master)

if [ -n "${CHANGES_TO_PUSH}" ]; then
  git push || die "git push failed"
else
  echo "No changes to push"
fi

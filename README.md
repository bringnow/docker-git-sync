# docker-git-sync
A docker image allowing you to sync a folder with a git repository.

To use it, you must pass the following environment variables:

* ```GIT_REPO_URL```: URL of the Git repository to sync to
* ```GIT_USER_EMAIL```: E-Mail address of author to show in commits
* ```GIT_USER_NAME```: Name of author to show in commits

Furthermore you need to put a valid SSH key and **known_hosts** file into the volume **/root/.ssh**.

Then this image will execute a cron job every minute and sync the contents of the volume **/sync-dir** to the specified git repository.

Of course you can mount the volumes to some directories of the host.

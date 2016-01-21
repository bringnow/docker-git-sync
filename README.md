# docker-git-sync
A docker image allowing you to sync a folder with a git repository.

To use it, you must pass the following environment variables:

* ```GIT_REPO_URL```: URL of the Git repository to sync to
* ```GIT_USER_EMAIL```: E-Mail address of author to show in commits
* ```GIT_USER_NAME```: Name of author to show in commits

Furthermore you need to setup the following two volumes:

* ```/root/.ssh```: This volume should contain a valid ssh key (```id_rsa``` and ```id_rsa.pub```) with write access to the specified git repository. Also it should contain a valid ```known_hosts``` file.
* ```/sync-dir```: The contents of this volume will be synced to the speciefied git repository. If this directory is not empty (but does not contain a git repository) the sync will be aborted. In this case you need to pass the flag ```--overwrite-local``` to the container or set the environment variable ```OVERWRITE_LOCAL``` to ```true```.

After proper setup this image will execute a cron job every minute and sync the contents of the volume */sync-dir* to the specified git repository.

Of course you can mount the volumes to some directories of the host.

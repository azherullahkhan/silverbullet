# Migrating GIT repositories from local to hosted Gitlab

To migrate GIT repos from your local git server to hosted GitLab and to ensure all the previous commit history and metadata are retained follow the below steps outlined

### Create a mirror of the GIT Repo

```python
git clone --mirror git@git01.int.co.lan:test-app
```

### Review the git remotes for the repo

```python
git remote -v
origin	git@git01.int.co.lan:test-app (fetch)
origin	git@git01.int.co.lan:test-app (push)
```

### Package the GIT repo using Tar

To move it from your hosted server to a machine where you've access to push your git repo into the new Hosted Git Server

```python
tar -cpzf test-app_git.tar ./test-app.git/
tar -xzf /tmp/test-app_git.tar
```

### Verify the Remotes

```python
git remote -v
origin	git@git01.int.co.lan:test-app (fetch)
origin	git@git01.int.co.lan:test-app (push)
```

### Review your git config or set it appropriate to your new Hosted Git Server

```python
git config --list
credential.helper=osxkeychain
user.email=azher_khan@hostedgitlab.com
user.name=AzherKhan
core.repositoryformatversion=0
core.filemode=true
core.bare=true
remote.origin.url=git@git01.int.co.lan:test-app
remote.origin.fetch=+refs/*:refs/*
remote.origin.mirror=true
```

### Rename your GIT origin Remote

```python
git remote rename origin old-origin
warning: Not updating non-default fetch refspec
	+refs/*:refs/*
	Please update the configuration manually if necessary.

git remote -v
old-origin	git@git01.int.co.lan:test-app (fetch)
old-origin	git@git01.int.co.lan:test-app (push)
```

### Create new origin pointing to the new Hosted Git Server

```python
git remote add origin git@hub.oci.hostedgitlab.com:app-dev/test-app.git

git remote -v
old-origin	git@git01.int.co.lan:test-app (fetch)
old-origin	git@git01.int.co.lan:test-app (push)
origin	git@hub.oci.hostedgitlab.com:app-dev/test-app.git (fetch)
origin	git@hub.oci.hostedgitlab.com:app-dev/test-app.git (push)
```

### Push all your changes to the new Git Server.

This command will create a new Git repo by the name `test-app` on the new Git Server and all the previous commits and history will be pushed as well.

Note: You need to have admin privileges to perform the below operation

```python
git push -u origin --all
```
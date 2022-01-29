------------------------------------------------------------------------------------------
                                       GIT Rough book
------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------
    List of Helm Commands
------------------------------------------------------------------------------------------

1. Edit an incorrect commit message
$ git commit --amend -m ”YOUR-NEW-COMMIT-MESSAGE”
$ git push <remote> <branch> --force


2. Undo ‘git add’ before committing
$ git reset


3. Undo your most recent commit
$ git reset --soft HEAD~1
# make changes to your working files as necessary
$ git add -A .$ git commit -c ORIG_HEAD


4. Revert your git repo to a previous commit
$ git checkout <SHA>


6. Remove local (untracked) files from current Git branch
$ git clean -f -n         # 1


7. Delete a Git branch both locally and remotely
$ git branch --delete --force <branchName>
$ git branch -D

To delete a remote branch:
$ git push origin --delete <branchName>


1. Autocorrect:
git config --global help.autocorrect 1

2. Add all of the change files to a commit:
git add –A


3. Switching back and forth between two branches:
git checkout -

5. See where all your branches are tracking from
git branch -vv

6. Pinpoint exactly when in the history a commit was made:
git bisect


7. Add & commit in a single command:
git commit -a -m 'commit message'

10. Revert repo to a previous commit
git checkout <SHA>


11. Undo a Git Merge
git revert HEAD
git revert -m 1 <SHA>


14. Autostash:
git config --global rebase.autoStash true


15. git reflog
git reflog


------------------------------------------------------------------------------------------
                                       GIT Rough book
------------------------------------------------------------------------------------------

Good Reference:
- http://git-scm.com/book/en/v2
- https://www.youtube.com/watch?v=ZDR433b0HJY

------------------------------------------------------------------------------------------
                                      GIT Commands Alias
------------------------------------------------------------------------------------------

alias ghelp='cat cat ~/.bash_profile | grep "git"'
alias gckbr='git checkout -b <branch_name> remotes/origin/<branch_name>'
alias gad='git add'
alias gbr='echo "git branch"; git branch'
alias gcl='git clone'
alias gci='git commit'
alias gdf='git diff'
alias gssl='echo "git config --global http.sslVerify false"; git config --global http.sslVerify false'
alias gcn='echo "git config --list"; git config --list'
alias gr='git review'
alias gs='echo "git status"; git status'
alias gsub='echo "git submodule update --init"; git submodule update --init'
alias gp='echo "git pull --ff-only"; git pull --ff-only'
alias glpr='echo "git log --pretty=oneline"; git log --pretty=oneline'
alias glp='git log -p'
alias glst='echo "git log --stat"; git log --stat'
alias gcat='echo "cat .git/config"; cat .git/config'
alias gcfp='git cat-file -p '
alias gcft='git cat-file -t '
alias gck='git checkout '
alias gsubs='echo "git submodule status"; git submodule status'
### GITHUB User
alias enablegithub='git config --global user.name "azherullakhan"; git config --global user.email "azherullahkhan@gmail.com"'
## ORG GIT User:
alias enableorggit='git config --global user.name "AzheKhan"; git config --global user.email "azher.khan@org.com"'

## By default enable Oracle GIT
enableorggit
git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit
## git graph
git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
## git lg -p

------------------------------------------------------------------------------------------
    List of GIT Commands
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


Create Git branch and checkout into it
git checkout -b <branchName>


7. Delete a Git branch both locally and remotely
$ git branch --delete --force <branchName>
$ git branch -D

To delete a remote branch:
$ git push origin --delete <branchName>

Push commits to remote origin

git push --set-upstream origin <branName>


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

------------------------------------------------------------------------------------------
                                          GIT Work Flow
------------------------------------------------------------------------------------------
cd /Users/azhekhan/infra
git checkout -b kafka-log-retention
git add playbooks/roles/kafka/templates/config/server.properties.j2
git commit -m "Updating Kafka Log Retention to 3 days" playbooks/roles/kafka/templates/config/server.properties.j2
git push --set-upstream origin kafka-log-retention

------------------------------------------------------------------------------------------
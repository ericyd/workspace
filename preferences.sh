#!/bin/sh

# just a random file for me to put some setup preferences

git config --global credential.helper osxkeychain
git config --global alias.lg "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)' --all"
git config --global alias.ca "commit --amend --no-edit"
git config --global alias.fp "fetch --prune"
git config --global alias.pfwl "push --force-with-lease"
git config --global alias.l "log --abbrev-commit --decorate --date=short --format=format:'%h, %aI - %s%d' -n 10"
git config --global alias.ll "log --abbrev-commit --decorate --date=short --format=format:'%H, %aI - %s%d' -n 5"
git config --global alias.cm "commit -m"
git config --global alias.s "status"
git config --global alias.back1 "reset HEAD~1"
git config --global user.name "Eric Dauenhauer"
git config --global user.email "eric@ericyd.com"
git config --global push.autosetupremote true

# zsh
alias up="cd .."
alias now="date +%Y-%m-%dT%H:%M:%S%z"
# or if using coreutils
alias now="gdate +%Y-%m-%dT%H:%M:%S%z"

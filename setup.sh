#!/bin/zsh

if [ -z "$(command -v brew)" ]; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

if [ -z "$(command -v virtualbox)" ]; then
    brew install --cask virtualbox
fi

if [ -z "$(command -v vagrant)" ]; then
    brew install vagrant
fi

if [ -z "$(vagrant plugin list | grep vagrant-vbguest)" ]; then
    vagrant plugin install vagrant-vbguest
fi

if [ -z "$(vagrant plugin list | grep vagrant-env)" ]; then
    vagrant plugin install vagrant-env
fi

if [ ! -f .env ]; then
    cp .env.sample .env
fi

cat > customization.sh <<-EOF
#!/bin/bash

# add statements here to customize your virtual machine

# If you prefer to use the locally installed postgres rather than docker, you'll want to auto-start the postgres server on startup
# sudo systemctl enable postgresql@12-main
# Or, if you prefer to use docker for your database, you may want to disable the default postgres service
# sudo systemctl stop postgresql@12-main
# sudo systemctl stop postgresql.service
# sudo systemctl disable postgresql.service
# sudo systemctl disable postgresql@12-main

# Add any git aliases you like, e.g.
# (thanks to https://stackoverflow.com/a/9074343/3991555)
# git config --global user.name My Name
# git config --global user.email email@domain.com
# git config --global alias.lg "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)' --all"
# git config --global alias.l "log --abbrev-commit --decorate --date=short --format=format:'%h, %aI - %s%d' -n 10"
# git config --global alias.ca "commit --amend --no-edit"
# git config --global alias.pfwl "push --force-with-lease"
EOF
chmod +x customization.sh

echo
echo ">> Contents of your .env file:"
echo

cat .env

echo
echo ">> Please review variables defined in .env file shown above."
echo ">> If you need to make any adjustments, edit .env file now!"

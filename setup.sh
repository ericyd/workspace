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
EOF
chmod +x customization.sh

echo
echo '>> Contents of your .env file:'
echo

cat .env

echo
echo '>> Please review variables defined in .env file shown above.'
echo '>> If you need to make any adjustments, edit .env file now!'

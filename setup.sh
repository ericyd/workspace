#!/bin/zsh

if [ -z "$(which brew)" ]; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

if [ -z "$(which virtualbox)" ]; then
    brew install --cask virtualbox
fi

if [ -z "$(which vagrant)" ]; then
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
EOF
chmod +x customization.sh

echo
echo '>> Contents of your .env file:'
echo

cat .env

echo
echo '>> Please review variables defined in .env file shown above.'
echo '>> If you need to make any adjustments, edit .env file now!'

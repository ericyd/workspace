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

# If you use GPG commit signing, this will be useful; it extends the amount of time your GPG password lives in the cache to a year
# [ ! -f /home/vagrant/.gnupg/gpg-agent.conf ] || [ -z "$(grep default-cache-ttl /home/vagrant/.gnupg/gpg-agent.conf)" ] && echo "default-cache-ttl 34560000" >> /home/vagrant/.gnupg/gpg-agent.conf
# [ ! -f /home/vagrant/.gnupg/gpg-agent.conf ] || [ -z "$(grep max-cache-ttl /home/vagrant/.gnupg/gpg-agent.conf)" ] && echo "max-cache-ttl 34560000" >> /home/vagrant/.gnupg/gpg-agent.conf
EOF
chmod +x customization.sh

echo
echo '>> Contents of your .env file:'
echo

cat .env

echo
echo '>> Please review variables defined in .env file shown above.'
echo '>> If you need to make any adjustments, edit .env file now!'

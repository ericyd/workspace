# Workspace

(heavily inspired by [markomitranic/docker-mac-vagrant](https://github.com/markomitranic/docker-mac-vagrant/tree/container-first))

- [What is this?](#what-is-this)
- [Get the goods](#get-the-goods)
- [Install dependencies and start VM](#install-dependencies-and-start-vm)
- [Set up VSCode](#set-up-vs-code)
- [Set up IntelliJ](#set-up-intelli-j)
- [Making changes to the VM](#making-changes-to-the-vm)
- [Git configuration](#git-configuration)
  - [SSH key](#ssh-key)
  - [GPG key](#gpg-key)
- [References](#references)
- [(potentially) useful tidbits](#potentially-useful-tidbits)

## What is this?

[Vagrant](https://www.vagrantup.com/) is a tool for configuring reproducible development environments.

This repo contains a simple setup script and the configuration files for a basic development virtual machine (VM).

## Get the goods

No git

```shell
curl -L https://github.com/ericyd/workspace/archive/refs/heads/main.zip -o workspace.zip
unzip -j workspace.zip -d workspace
rm workspace.zip
cd workspace
```

Yes git

```shell
git clone git@github.com:ericyd/workspace
cd workspace
```

## Install dependencies and start VM

**Important! If you're running a Mac M1 or M2 chip (i.e. arm64), you must [download VirtualBox from the website and install manually](https://www.virtualbox.org/wiki/Downloads). This might change in the future but currently homebrew will try to install the x86 installation.**

These commands will

1. Install base dependencies (homebrew, virtualbox, vagrant)
2. Set up your basic `.env` file
3. Create a basic `customization.sh` file. This is not tracked by git. The purpose is to have a place where you can add customization to your own VM that isn't necessarily intended to be shared with a team. For example, if you prefer a specific shell or software, you can add commands to install it here. If you intend to add any customizations, its best to do it before you spin up the VM, but you can always do it later too.
4. Spin up and provision your VM
5. Set up SSH forwarding so you can use your host machine's SSH keys in the VM
   - Note: you can always use `vagrant ssh` to access the VM, instead of `ssh dev`. However, `vagrant ssh` requires you to be in this working directory. Setting up ssh forwarding on the host machine allows you to ssh in from any terminal/directory.

```shell
./setup.sh
# add commands to customization.sh if desired
vagrant up --provision
vagrant ssh-config >>  ~/.ssh/config
```

## Set up VSCode

0. Install VSCode on the host machine
1. Install dependencies on the host:
   - Cmd+Shift+P and type "install remote development"
   - Install plugins
     1. Remote - Containers
     2. Remote - SSH.
2. Connect to the VM:
   1. Cmd+Shift+P and type "Remote-SSH: Connect to Host"
   2. Pick "dev" from the list.

When you start an integrated terminal, it should already be SSH'd in to the machine.

The working directory should be in the VM too

## Set up IntelliJ

_Disclaimer: IntelliJ remote development is a little more complex than VSCode. IntelliJ is not my primary IDE so the below instructions are provided as a best guess. [The official documentation](https://www.jetbrains.com/help/idea/remote-development-overview.html#workflow) is probably better, but a summary is below_

1. Install IntelliJ on the host machine
   - Also make sure you have Jetbrains Gateway installed. [Check the documentation](https://www.jetbrains.com/help/idea/jetbrains-gateway.html) to verify you have Gateway installed (it will likely be included by default assuming you have a fairly recent version of IntelliJ).
2. Install IntelliJ on the VM
   - `sudo snap install intellij-idea-ultimate --classic`, or
   - `sudo snap install intellij-idea-community --classic`
   - [Reference](https://www.jetbrains.com/idea/download/#section=linux)
3. With the VM running, start the dev server
   - `./home/vagrant/.cache/JetBrains/RemoteDev/dist/remote-dev-server.sh`
   - [Reference](https://www.jetbrains.com/help/idea/remote-development-overview.html#workflow)
4. Copy the connection link
5. On the host machine, paste the link into a browser and let Jetbrains Gateway handle the connection

## Making changes to the VM

You can always install things ad-hoc, but to use `provision.sh` or `customization.sh`, you must run Vagrant provisioning again.

The easiest way to do this:

```shell
vagrant halt
vagrant up --provision
```

## Git configuration

### SSH key

```shell
# generate key
ssh-keygen -t ed25519 -C "your_email@example.com"

# start ssh-agent
eval "$(ssh-agent -s)"

# add key to agent
ssh-add ~/.ssh/id_ed25519

# print public key and add to GitHub
cat ~/.ssh/id_ed25519.pub
```

### GPG key

```shell
# generate new key (must be 4096 bits for GitHub). Alternatively, can use the CLI prompts: gpg --full-generate-key
gpg --quick-generate-key "My Fullname (some description) <my_email@example.com>" rsa4096 default none

# get the key ID (the string after "sec   rsa4096")
# For example, if your output looks like this↓, then the key ID is BA94D8274CE2874D
#   sec   rsa4096/BA94D8274CE2874D 2022-09-02 [SC]
#         9C4A19B3B413717AF6AA7B5BBA94D8274CE2874D
#   uid                 [ultimate] My Fullname (some description) <test@example.com>
gpg --list-secret-keys --keyid-format=long

# add key ID to git
git config --global user.signingkey <ID>
git config --global commit.gpgsign true

# print key and add to GitHub
gpg --armor --export <ID>
```

## References

- [Useful tips-n-tricks: github.com/markomitranic/docker-mac-vagrant](https://github.com/markomitranic/docker-mac-vagrant/tree/container-first)
- [Vagrant](https://www.vagrantup.com/)
  - [Docs](https://www.vagrantup.com/docs)
- [Git SSH configuration](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)
- [Git GPG commit signing](https://docs.github.com/en/authentication/managing-commit-signature-verification/generating-a-new-gpg-key)
- [IntelliJ installation](https://www.jetbrains.com/idea/download/#section=linux)
- [IntelliJ remote dev workflow](https://www.jetbrains.com/help/idea/remote-development-overview.html#workflow)
- [IntelliJ Gateway installation](https://www.jetbrains.com/help/idea/jetbrains-gateway.html)

## (potentially) useful tidbits

**Append contents of host machine file into the VM**

This example copies the contents of an SSH public key into the authorized_keys file of the VM

```shell
cat ~/.ssh/id_ed25519.pub | xargs -J {} ssh dev 'echo "{}" >> ~/.ssh/authorized_keys'
```

**Copy a file from host machine to the VM**

This example copies the global Git config, but you can swap the path for any other file you'd like to copy, e.g. `~/.bashrc`

```shell
scp ~/.gitconfig dev:~/.gitconfig
```

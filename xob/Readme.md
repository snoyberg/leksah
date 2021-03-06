# Xob Leksah

A Fedora 22 based Vagrant Box for Haskell development.

## Provides

An easy way to get up and running with:

* Leksah

* GHC 7.10.1

* GHCJS (new "imporved-base" branch)

* GHC 7.10.1 running on Wine


## Setup

Finished VM takes about 16GB or so of disk space.  Install VirtualBox 4.3.28 (edit
the setup.sh if you choose a newer version) and Vagrant then run:

    vagrant box add -name fedora-22 http://download.fedoraproject.org/pub/fedora/linux/releases/22/Cloud/x86_64/Images/Fedora-Cloud-Base-Vagrant-22-20150521.x86_64.vagrant-virtualbox.box
    git clone https://github.com/leksah/leksah
    cd leksah/xob

Modify the Vagrantfile if you want to reduce or increase memory or the number
of CPUs, then run:

    vagrant up

Wait... a... long... time...

If all goes well you will probably find it at the gnome lock screen when you return.
Username is vagrant and password vagrant.  You can disable the lock screen in the
system settings under **Power**.

## Rerunning Setup

If something goes wrong in` vagrant up` or you want to try to update the VM by rerunning
the setup script you can use `vagrant provision` on the host machine to do this.

## Usage

The VM should log in automatically as the user `vagrant` (password `vagrant`)
and run Leksah.

To build a GHCJS package use the `JS` button in Leksah or run

    cabal install --ghcjs

To use Wine and MinGW to and run a Windows exe:

    export WINEDEBUG=-all
    wine cabal install hello
    wine hello

The `WINEDEBUG=-all` turns off all the debug messages from Wine.


## Warnings

* This is brand spanking new (needs testing).
* There is some kind of input latency issue that affects Leksah as well as
  gedit (not sure what it is).
* GHCJS is the new “improved-base” branch and not the master branch so
  you may find some examples do not work.  Expect problems and make sure you
  mention that you are using “improved-base” when reporting them.

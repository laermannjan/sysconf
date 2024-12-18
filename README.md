# System setup and configuration

On macOS 
1. install the command line tools `xcode-select --install` 
1. clone this repo (you will be prompted via GUI to install the command line tools if you haven't executed 1.)
1. run `./install` - you will be asked for the user password (`BECOME`) and the ansible vault password. You can create a file containing the vault password and run `VAULT_PASSWORD_FILE=<path to that file> ./install` to not be prompted (makes it easier to check for typos and you don't have to reenter after failed runs)
1. some things might fail on first run - don't worry, read the error try again :)

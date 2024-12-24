# System setup and configuration

On macOS 
1. install the command line tools `xcode-select --install` 
1. run the bootstrap script `curl -fsSL $(https://raw.githubusercontent.com/laermannjan/sysconf/refs/heads/main/ansible/install)`
  - this will clone the repo to `~/sysoncf` from which you can run `./ansible/install` again, should it fail
1. run `./install` - you will be asked for the user password (`BECOME`) and the ansible vault password. You can create a file containing the vault password and run `VAULT_PASSWORD_FILE=<path to that file> ./install` to not be prompted (makes it easier to check for typos and you don't have to reenter after failed runs)
1. Ansible playbook might fail because some files are in the way, see if you can just delete them (like an edited `~/.config/fish` dir)
1. Restart / log out and in after the the playbook ran successfully. Then start all the services: Docker, Karabiner, Raycast, etc. some of them will require accessibility stuff, just restart after starting all of them, the options should appear.
1. `CMD+\`` in wezterm will not work initially, you need to disable the window switcher in `Settings > Keyboard > Keyboard Shortcuts > Keyboard > Move focus to next window`

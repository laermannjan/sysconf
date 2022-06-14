# Install fisher, if it does not exist
if status is-interactive && ! functions --query fisher
    curl -sL https://git.io/fisher | source
    if test -f $__fisher_path/fish_plugins
        fisher update
    else
        fisher install jorgebucaran/fisher
    end
end

#source every file in conf.d/
source $__fisher_path/conf.d/fisher_path.fish

fish_add_path -g ~/bin
fish_add_path -g ~/.local/bin
fish_add_path -g ~/.emacs.d/bin
fish_add_path -g ~/.cargo/bin

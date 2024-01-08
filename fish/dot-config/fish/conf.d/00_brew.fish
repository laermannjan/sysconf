status --is-interactive || exit

switch (uname)
    case Linux
        if test -f /home/linuxbrew/.linuxbrew/bin/brew
            eval (/home/linuxbrew/.linuxbrew/bin/brew shellenv)
        else
            exit
        end 
    case Darwin
        eval (/opt/homebrew/bin/brew shellenv)
end

# install wrapper of rcmdnk/homebrew-file
# tracks all brew (un-)installs in ~/.config/brewfile/Brewfile
# binary: brew-file
if test -f (brew --prefix)/etc/brew-wrap.fish
    source (brew --prefix)/etc/brew-wrap.fish
end

test -f /home/linuxbrew/.linuxbrew/bin/brew && set brew_prefix /home/linuxbrew/.linuxbrew
test -f /opt/homebrew/bin/brew && set brew_prefix /opt/homebrew
if set -q brew_prefix
    set -gx HOMEBREW_NO_ANALYTICS 1
    set -gx HOMEBREW_BUNDLE_FILE $XDG_CONFIG_HOME/homebrew/Brewfile
    $brew_prefix/bin/brew shellenv | source
    set -p fish_complete_path $brew_prefix/share/fish/completions
    set -p fish_complete_path $brew_prefix/share/fish/vendor_completions.d
    set -a fish_function_path $brew_prefix/share/fish/vendor_functions.d
end

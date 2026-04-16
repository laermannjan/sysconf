set -q XDG_DATA_HOME || set -l XDG_DATA_HOME ~/.local/share
set -g fisher_path $XDG_DATA_HOME/fisher
set -p fish_function_path $fisher_path/functions
set -p fish_complete_path $fisher_path/completions
for f in $fisher_path/conf.d/*.fish; source $f; end

if status is-interactive && not functions -q fisher
    curl -sL https://git.io/fisher | source
    fisher update
end

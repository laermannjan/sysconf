function __fish_list_current_token --description 'List contents of token under the cursor if it is a directory, otherwise list the contents of the current directory'
    set -l val "$(commandline -t | string replace -r '^~' "$HOME")"
    set -l cmd
    set -l ls_cmd ls
    if command -q eza
        set ls_cmd eza --long --group-directories-first
    end
    if type -q lla
        set ls_cmd lla
    end
    if test -d $val
        set cmd $ls_cmd $val
    else
        set -l dir (dirname -- $val)
        if test $dir != . -a -d $dir
            set cmd $ls_cmd $dir
        else
            set cmd $ls_cmd
        end
    end
    __fish_echo $cmd
end

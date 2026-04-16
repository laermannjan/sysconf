complete --command savid-retag --short-option T --long-option no-artist-title --description "Don't prefix title tag with artist"
complete --command savid-retag --short-option h --long-option help            --description "Show help"
complete --command savid-retag --force-files --condition "not __fish_seen_subcommand_from -"

function _savid_sanitize --description "Sanitize a string for use in filenames"
    string replace -ra '[<>:"/\\\\|?*\x00-\x1f]' '' -- $argv[1] \
    | string replace -ra '\s+' ' ' \
    | string trim
end

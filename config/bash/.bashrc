# Start ssh-agent if not running, connect to system agent otherwise
if [ -z "$SSH_AUTH_SOCK" ]; then
    eval $(ssh-agent -s)
fi

# add every ssh key to the agent; prompts for passwords
for key in ~/.ssh/id_*; do
    if [ -f "$key" ] && [[ "$key" != *.pub ]] && ! ssh-add -L | grep -q " $key\$"; then
        if [ "$(uname)" = "Darwin" ]; then
            ssh-add --apple-use-keychain "$key"
        elif command -v keychain >/dev/null 2>&1; then
            eval $(keychain --eval --quiet "$key")
        else
            ssh-add "$key"
        fi
    fi
done

import sys
from pyinfra.api import operation
from pyinfra.api.exceptions import OperationError
from pyinfra.facts.files import Directory, File
from pyinfra.operations import brew, files, server
from pyinfra.facts.server import Command, Home, User, Which
from pyinfra import host, logger
from pathlib import Path


# 1. Install fish and setup as login shell ========================================================

fish_path = "/opt/homebrew/bin/fish"
user = host.get_fact(User)

brew.packages(
    name="Install fish",
    packages="fish",
    _if=lambda: host.get_fact(Which, "fish") != fish_path,
)

etc_shells = files.line(
    name="Add fish to /etc/shells",
    path="/etc/shells",
    line=fish_path,
    present=True,
    _sudo=True,
)

server.shell(
    name=f"Make fish login shell for {user}",
    commands=f"dscl . -create /Users/{user} UserShell {fish_path}",
    _sudo=True,
    _if=lambda: host.get_fact(
        Command, f"dscl . -read /Users/{user} UserShell | awk '{{print $2}}' || true"
    )
    != fish_path
    and not etc_shells.did_error(),
)

# 2. Install packages


brew.packages(
    name="Install essential packages",
    packages=[
        "bat",
        "coreutils",
        "curl",
        "eza",
        "file-formula",
        "fzf",
        "jq",
        "lz4",
        "ripgrep",
        "starship",
        "unzip",
        "wget",
    ],
)


# NOTE: should also install node, but covered with fish nvm
brew.packages(
    name="Install neovim and dependencies",
    packages=["neovim", "ripgrep", "tree-sitter", "tree-sitter-cli"],
)


brew.packages(
    name="Install git related tools",
    packages=[
        "git",
        "git-lfs",
        "git-delta",
        "lazygit",
    ],
)


brew.casks(
    name="Install must-have apps",
    casks=[
        "1password",
        "wezterm",
        "linearmouse",
        "karabiner-elements",
        "raycast",
        "tailscale-app",
        "podman-desktop",
        "the-unarchiver",
        "arc",
        "librewolf",
    ],
)


brew.packages(
    name="Install extra packages",
    packages=[
        "awscli",
        "direnv",
        "doggo",
        "ghostscript",
        "httpie",
        "imagemagick",
        "p7zip",
        "parallel",
        "yt-dlp",
        "zoxide",
        "lazydocker",
    ],
)

brew.casks(
    name="Install extra apps",
    casks=[
        "chatgpt",
        "claude",
        # "claude-code", # NOTE: read docs, must disable autoupdater and upgrade manually, kinda annoying
        "utm",
        "signal",
        "nextcloud",
        "jetbrains-toolbox",
        "monitorcontrol",
    ],
)

lang_tools = brew.packages(
    name="Install programming language tools",
    packages=[
        "uv",
        "golang",
        "rustup",
    ],
)

server.shell(
    name="Install python",
    commands="uv python install",
    _if=lambda: not lang_tools.did_error(),
)

# server.shell(
#     name="Install pynvim",
#     commands="uv tool install --upgrade pynvim",  # FIXME: fails at the moment: https://github.com/neovim/pynvim/issues/595
#     _if=lambda: not lang_tools.did_error(),
# )
server.shell(
    name="Install beancount",
    commands="uv tool install --upgrade beancount",
    _if=lambda: not lang_tools.did_error(),
)


server.shell(
    name="Install rust",
    commands="rustup-init -y",
    _if=lambda: not lang_tools.did_error(),
)

fisher = server.shell(
    name="Install fisher",
    commands=[
        "curl -fsSL git.io/fisher | source",
        "fisher update </dev/null",  # FIXME:  </dev/null is need due to: https://github.com/jorgebucaran/fisher/issues/742
        "fisher install jorgebucaran/fisher </dev/null",
    ],
    _if=lambda: not host.get_fact(
        File, f"{host.get_fact(Home)}/.config/fish/functions/fisher.fish"
    ),
    _shell_executable=fish_path,
)

server.shell(
    name="Install node",
    commands=[
        "fisher update </dev/null",
        "fisher install jorgebucaran/nvm.fish </dev/null",
        "nvm install lts",
        "set -q nvm_default_version || set -Ux nvm_default_version lts",
    ],
    _if=lambda: not lang_tools.did_error()
    and not fisher.did_error()
    and not host.get_fact(Which, "node"),
    _shell_executable=fish_path,
)


@operation(is_idempotent=True)
def link_dotiles(config_source: str | None = None, config_target: str | None = None):
    if config_source is None:
        sysconf_dir = host.get_fact(Command, "echo $SYSCONF_DIR || true")

        if not sysconf_dir:
            raise OperationError("$SYSCONF_DIR not set")
        config_source = f"{sysconf_dir}/config"

    if config_target is None:
        config_target = f"{host.get_fact(Home)}/.config"
        files.directory._inner(path=config_target)

    configs = host.get_fact(
        Command, f"find {config_source} -maxdepth 1 -mindepth 1 || true"
    )

    if configs:
        for config in configs.splitlines():
            yield from files.link._inner(
                path=f"{config_target}/{Path(config).name}",
                target=config,
                force=True,
                force_backup=True,
            )


link_dotiles(name="Link dotfiles")

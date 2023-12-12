set -gx STARSHIP_CONFIG "$HOME/.config/starship/starship.toml"

if status --is-interactive && command -s starship
    starship init fish | source
end


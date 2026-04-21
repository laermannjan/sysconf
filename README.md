# sysconf

> [!Important]
> Do not pipe `curl` into `bash` as the script won't run in interactive mode and will skip setup prompts.

```sh
bash -c "$(curl -fsSL https://raw.githubusercontent.com/laermannjan/sysconf/HEAD/sysconf.sh)"
```

## Goal

Bootstrap local dev machine: system preferences, shell setup, dotfiles, packages/apps.
Priority is macOS. Linux is secondary.
Changes flow both ways: repo -> system (bootstrap), system -> repo (live system edits), without manual intervention.

I should not have to care or think about how `sysconf` operates when using my machine. It should get out of my way. Daily use friction is cursed.

Optimize for the live system, not the setup code. Things must work as expected.
When automation would become brittle or complex, manual is the right call. 
The system matters more than the code that built it.

Setup must be complete.
Surprises or caveats, edge cases that only happen on one platform, failures that only occur in specific scenarios -> the setup isn't ready. Either fix it or don't include it.
Setup debt isn't worth live system complexity.

A tool must justify itself against bash: complexity, learning curve, new workflow. Scope is simple. Don't use tools for problems you don't have.

### Already Tried

### Ansible
Offers: Idempotency, organized roles, ecosystem
Why not: Thinking "the ansible way" (roles, yaml, facts) becomes overhead. Constant lookups, galaxy caveats, workarounds. No payoff.

### Nix + home-manager
Offers: Reproducibility, declarative system
Why not: Paradigm everywhere, iteration heavy, broke edit-and-git flow, required to learn an insane amount of context, tooling, caveats, specifics.

### Chezmoi
Offers: Dotfile syncing, script hooks (only_once, before, after), templating
Why not: Templates break bidirectional flow. Only symlink mode relevant, but most complexity is in bash script now and will be in bash scripts in chezmoi, so why chezmoi at all? Only potential could be script ordering and trigger framework.


# Custom functions
## 1password
Load secrets from 1Password directly into shell, when entering the directory without putting the secret into the `.env`.

1. Install 1password and 1password-cli (v2)
1. Enable the gui to cli integration: **Settings > Developer Integrate 1Password CLI** - this means you do not have to do the
   `eval (op signin <account>)` stuff in your shell (config), but 1password gui will ask you which account to connect to when the
   cli tries to fetch a secret.
1. Fetch the secret in the `.envrc`
```bash
from_op ENV_VAR="op://<vault_name>/<item_name>/<field_name>"
```

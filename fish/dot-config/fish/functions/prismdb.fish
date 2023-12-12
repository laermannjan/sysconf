function get_alcemy_pg_url;
    set --local options 'l/localhost'
    argparse $options -- $argv

    set --query _flag_localhost; and set --local host "localhost"; or set --local host "dev-db-instance.cxwee7sgwz6s.eu-central-1.rds.amazonaws.com"

    switch (uname)
        case Linux
            alias clipboard "xclip -selection clipboard"
        case Darwin
            alias clipboard pbcopy
    end

    set --local secret_suffix "_db_instance_password"
    set --local secret_name (aws secretsmanager list-secrets |  jq -r '.[][] | .Name' | grep $secret_suffix | fzy)
    set --local secret (aws secretsmanager get-secret-value --secret-id $secret_name | jq -r .SecretString)

    set --local env_name (string replace $secret_suffix '' $secret_name)
    echo postgresql://{$env_name}:{$secret}@{$host}:5432/alcemy_prism_{$env_name} | clipboard
end

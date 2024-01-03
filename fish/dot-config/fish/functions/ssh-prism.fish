function ssh-prism
    set target $ENVIRONMENT_SLUG
    set port 5432

    # if test (count $argv) -eq 1 >/dev/null
    #     set target $argv[1]
    # end

    argparse --name=ssh-prism "p/port=" "t/target=?" -- $argv
    if test -n "$_flag_target"
        set target $_flag_target
    end

    if count $argv >/dev/null
        set target $argv[1]
    end

    if test -n "$_flag_port"
        set port $_flag_port
    end

    set suffix "db-instance.cxwee7sgwz6s.eu-central-1.rds.amazonaws.com:5432"
    set bastion "alhambra-dev.alcemy.tech"

    switch $target
        case "dyn_*"
            set url "prism-$target-$suffix"
        case "testing|staging"
            set url "dev-$suffix"
        case prod
            set url "prod-$suffix"
            set bastion "alhambra-prod.alcemy.tech"
        case '*'
            echo "unknown target '$target'"
            return 1
    end
    echo "forwarding **$target** to port $port"
    set fish_trace 1
    ssh -i ~/.ssh/id_alcemy -NL $port:$url ec2-user@$bastion
end

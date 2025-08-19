return {
    settings = {
        ['helm-ls'] = {
            yamlls = {
                path = '~/.local/share/nvim/mason/bin/yaml-language-server',
                config = {
                    schemas = {
                        ['https://raw.githubusercontent.com/argoproj/argo-workflows/master/api/jsonschema/schema.json'] = 'infrastructure/helm-chart/**/*workflow*.yaml',
                    },
                },
            },
        },
    },
}

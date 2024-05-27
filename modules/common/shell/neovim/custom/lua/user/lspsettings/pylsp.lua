return {
	settings = {
		pylsp = {
			plugins = {
				black = { enabled = false },
				autopep8 = { enabled = false },
				flake8 = { enabled = false },
				mccabe = { enabled = false },
				pyflakes = { enabled = false },
				pylint = { enabled = false },
				pylsp_mypy = { enabled = true },
				pycodestyle = {
					ignore = { "E501" },
				},
				yapf = { enabled = false },
			},
		},
	},
}

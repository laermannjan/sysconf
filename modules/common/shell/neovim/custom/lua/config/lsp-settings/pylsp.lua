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
            ruff = { enabled = false },
            rope_rename = { enabled = false },
            jedi_rename = { enabled = false },
            pylsp_rope = { enabled = true, rename = true },
         },
      },
   },
}

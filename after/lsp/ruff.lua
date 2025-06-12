return {
	init_options = {
		settings = {
			lineLength = 160,
			lint = {
				preview = true,
				select = {
					"F", -- pyflakes
					"W6", -- warnings
					"E1", -- indentation
					"E2", -- whitespace
					"E501", -- line length
					"E71", -- value comparison
					"E72", -- type comparison & exceptions
					"E702", -- semicolons
					"E703", -- semicolons
					"E731", -- lambdas
					"W191", -- indentation
					-- "W291", -- trailing whitespace
					-- "W293", -- blank line whitespace
					"I002", -- missing import
					"UP039", -- unnecessary parens
					"PD", -- pandas
					"NPY", -- numpy
					"RUF", -- ruff specific
				},
				ignore = {
					"E261", -- ignore whitespace before comments
					"E226", -- ignore whitespace before comments
					-- "F403", -- allow import *
					"F405", -- allow import from __future__
					"PD901", -- allow df as name
				},
			},
		},
	},
	on_attach = function(client, bufnr)
		client.server_capabilities.hoverProvider = false
	end,
}

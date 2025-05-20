return {
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",
			},
			diagnostics = {
				globals = {
					"vim",
					"require",
					"Utils",
					"P",
					"s",
					"t",
					"i",
					"fmt",
					"rep",
				},
			},
		},
	},
}

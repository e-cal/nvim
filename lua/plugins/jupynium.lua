return {
	"kiyoon/jupynium.nvim",
	-- build = "source $VIRTUALENV_HOME/nvim/bin/activate && pip install .",
	dependencies = {
		"rcarriga/nvim-notify",
		"stevearc/dressing.nvim",
	},
	opts = {
		jupyter_command = "LD_LIBRARY_PATH=/opt/cuda/lib64:/opt/cuda-11.7/lib64:/run/opengl-driver/lib:$NIX_LD_LIBRARY_PATH jupyter",
		use_default_keybindings = false,
		-- syntax_highlight = { enable = false },
		notify = {
			ignore = {
				"download_ipynb",
				-- "error_download_ipynb",
				-- "attach_and_init",
				-- "error_close_main_page",
				-- "notebook_closed",
			},
		},
	},
}

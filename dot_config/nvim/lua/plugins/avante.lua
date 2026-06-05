return {
	"yetone/avante.nvim",
	event = "VeryLazy",
	lazy = false,
	version = false,
	build = "make",
	opts = {
		provider = "gemini",

		providers = {
			gemini = {
				model = "gemini-1.5-pro-latest",
				extra_request_body = {
					max_tokens = 4096,
					temperature = 0,
				},
			},
			claude = {
				endpoint = "https://api.anthropic.com",
				model = "claude-3-5-sonnet-20240620",
				extra_request_body = {
					max_tokens = 4096,
					temperature = 0,
				},
			},
		},

		windows = {
			position = "right",
			width = 42,
			sidebar_header = {
				align = "center",
				rounded = true,
			},
		},
		mappings = {
			ask = "<leader>aa",
			edit = "<leader>ae",
			refresh = "<leader>ar",
			focus = "<leader>af",
			toggle = {
				default = "<leader>at",
			},
		},
	},
	dependencies = {
		"stevearc/dressing.nvim",
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		"nvim-tree/nvim-web-devicons",
		{
			"MeanderingProgrammer/render-markdown.nvim",
			opts = { file_types = { "markdown", "Avante" } },
			ft = { "markdown", "Avante" },
		},
	},
}

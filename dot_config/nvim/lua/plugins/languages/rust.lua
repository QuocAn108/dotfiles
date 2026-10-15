return {
	-- Rustaceanvim: Gold standard for Rust LSP, DAP, and code actions
	{
		"mrcjkb/rustaceanvim",
		version = "^5",
		lazy = false,
		ft = { "rust" },
		config = function()
			vim.g.rustaceanvim = {
				server = {
					on_attach = function(client, bufnr)
						vim.keymap.set("n", "<leader>ca", function()
							vim.cmd.RustLsp("codeAction")
						end, { buffer = bufnr, desc = "Rust: Code Action" })

						vim.keymap.set("n", "<leader>dr", function()
							vim.cmd.RustLsp("debuggables")
						end, { buffer = bufnr, desc = "Rust: Debuggables" })

						vim.keymap.set("n", "<leader>rr", function()
							vim.cmd.RustLsp("runnables")
						end, { buffer = bufnr, desc = "Rust: Runnables" })

						vim.keymap.set("n", "<leader>em", function()
							vim.cmd.RustLsp("expandMacro")
						end, { buffer = bufnr, desc = "Rust: Expand Macro" })

						vim.keymap.set("n", "<leader>ee", function()
							vim.cmd.RustLsp("explainError")
						end, { buffer = bufnr, desc = "Rust: Explain Error" })

						vim.keymap.set("n", "K", function()
							vim.cmd.RustLsp({ "hover", "actions" })
						end, { buffer = bufnr, desc = "Rust: Hover Actions" })
					end,
					default_settings = {
						["rust-analyzer"] = {
							cargo = {
								allFeatures = true,
								loadOutDirsFromCheck = true,
								runBuildScripts = true,
							},
							check = {
								command = "clippy",
							},
							procMacro = {
								enable = true,
							},
							diagnostics = {
								enable = true,
							},
						},
					},
				},
			}
		end,
	},

	-- Crates.nvim: Cargo.toml helper (versions, features, docs)
	{
		"saecki/crates.nvim",
		event = { "BufRead Cargo.toml" },
		opts = {
			lsp = {
				enabled = true,
				actions = true,
				completion = true,
				hover = true,
			},
		},
	},
}

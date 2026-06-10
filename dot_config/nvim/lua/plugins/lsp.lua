return {
	-- Main LSP Configuration
	"neovim/nvim-lspconfig",
	dependencies = {
		{ "folke/neodev.nvim", opts = {} },
		{ "williamboman/mason.nvim", opts = {} },
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		{ "j-hui/fidget.nvim", opts = {} },
		"saghen/blink.cmp",
		{ "mfussenegger/nvim-lint" },
		{ "lukas-reineke/lsp-format.nvim" },
	},

	config = function()
		require("neodev").setup({
			library = {
				enabled = true,
				plugins = true,
				types = true,
			},
		})

		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
			callback = function(event)
				local map = function(keys, func, desc, mode)
					mode = mode or "n"
					vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
				end

				map("grn", vim.lsp.buf.rename, "[R]e[n]ame")
				map("gra", vim.lsp.buf.code_action, "[G]oto Code [A]ction", { "n", "x" })
				map("grr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
				map("gri", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
				map("grd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
				map("grD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
				map("gO", require("telescope.builtin").lsp_document_symbols, "Open Document Symbols")
				map("gW", require("telescope.builtin").lsp_dynamic_workspace_symbols, "Open Workspace Symbols")
				map("grt", require("telescope.builtin").lsp_type_definitions, "[G]oto [T]ype Definition")

				local function client_supports_method(client, method, bufnr)
					if vim.fn.has("nvim-0.11") == 1 then
						return client:supports_method(method, bufnr)
					else
						return client.supports_method(method, { bufnr = bufnr })
					end
				end

				local client = vim.lsp.get_client_by_id(event.data.client_id)
				if
					client
					and client_supports_method(
						client,
						vim.lsp.protocol.Methods.textDocument_documentHighlight,
						event.buf
					)
				then
					local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
					vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
						buffer = event.buf,
						group = highlight_augroup,
						callback = vim.lsp.buf.document_highlight,
					})
					vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
						buffer = event.buf,
						group = highlight_augroup,
						callback = vim.lsp.buf.clear_references,
					})
					vim.api.nvim_create_autocmd("LspDetach", {
						group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
						callback = function(event2)
							vim.lsp.buf.clear_references()
							vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
						end,
					})
				end

				if
					client
					and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf)
				then
					map("<leader>th", function()
						vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
					end, "[T]oggle Inlay [H]ints")
				end
			end,
		})

		vim.diagnostic.config({
			severity_sort = true,
			float = { border = "rounded", source = "if_many" },
			underline = { severity = vim.diagnostic.severity.ERROR },
			signs = vim.g.have_nerd_font and {
				text = {
					[vim.diagnostic.severity.ERROR] = "󰅚 ",
					[vim.diagnostic.severity.WARN] = "󰀪 ",
					[vim.diagnostic.severity.INFO] = "󰋽 ",
					[vim.diagnostic.severity.HINT] = "󰌶 ",
				},
			} or {},
			virtual_text = {
				source = "if_many",
				spacing = 2,
				format = function(diagnostic)
					local diagnostic_message = {
						[vim.diagnostic.severity.ERROR] = diagnostic.message,
						[vim.diagnostic.severity.WARN] = diagnostic.message,
						[vim.diagnostic.severity.INFO] = diagnostic.message,
						[vim.diagnostic.severity.HINT] = diagnostic.message,
					}
					return diagnostic_message[diagnostic.severity]
				end,
			},
		})

		local capabilities = require("blink.cmp").get_lsp_capabilities()

		local servers = {
			lua_ls = {
				mason_package = "lua-language-server",
				settings = {
					Lua = {
						runtime = { version = "LuaJIT" },
						completion = { callSnippet = "Replace" },
						diagnostics = {
							globals = { "vim" },
							disable = { "undefined-field" },
						},
						workspace = {
							library = vim.api.nvim_get_runtime_file("", true),
							checkThirdParty = false,
						},
						telemetry = { enable = false },
					},
				},
			},
			gopls = {
				mason_package = "gopls",
				settings = {
					gopls = {
						analyses = {
							unusedparams = true,
							shadow = true,
						},
						staticcheck = true,
					},
				},
			},
			pyright = {
				mason_package = "pyright",
			},
			jdtls = {
				mason_package = "jdtls",
				cmd = {
					"jdtls",
					string.format(
						"--jvm-arg=-javaagent:%s",
						vim.fn.expand("~/.local/share/nvim/mason/packages/jdtls/lombok.jar")
					),
				},
			},
			rust_analyzer = {
				mason_package = "rust-analyzer",
				settings = {
					["rust-analyzer"] = {
						cargo = {
							allFeatures = true,
						},
						checkOnSave = {
							command = "clippy",
						},
					},
				},
			},
		}

		local ensure_installed = {}
		for server_name, server in pairs(servers) do
			table.insert(ensure_installed, server.mason_package or server_name)
		end

		vim.list_extend(ensure_installed, { "stylua", "gofumpt", "golines", "black", "flake8" })
		require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

		require("mason-lspconfig").setup({
			ensure_installed = {},
			automatic_installation = false,
			handlers = {
				function(server_name)
					if server_name == "jdtls" then
						local lombok_path = vim.fn.expand("~/.local/share/nvim/mason/packages/jdtls/lombok.jar")

						local bundles = {}
						local mason_registry = require("mason-registry")

						if mason_registry.is_installed("java-debug-adapter") then
							local pkg = mason_registry.get_package("java-debug-adapter")
							local jar_path = vim.fn.glob(
								pkg:get_install_path() .. "/extension/server/com.microsoft.java.debug.plugin-*.jar",
								true
							)
							if jar_path ~= "" then
								table.insert(bundles, jar_path)
							end
						end

						if mason_registry.is_installed("java-test") then
							local pkg = mason_registry.get_package("java-test")
							local test_jars =
								vim.split(vim.fn.glob(pkg:get_install_path() .. "/extension/server/*.jar", true), "\n")
							for _, jar in ipairs(test_jars) do
								if jar ~= "" then
									table.insert(bundles, jar)
								end
							end
						end

						require("lspconfig").jdtls.setup({
							cmd = {
								"jdtls",
								"-configuration",
								vim.fn.expand("~/.cache/jdtls/config"),
								"-data",
								vim.fn.expand("~/.cache/jdtls/workspace/" .. vim.fn.fnamemodify(vim.fn.getcwd(), ":t")),
								"--jvm-arg=-javaagent:" .. lombok_path,
								"--jvm-arg=-Xbootclasspath/a:" .. lombok_path,
							},
							root_dir = require("lspconfig.util").root_pattern(".git", "mvnw"),
							capabilities = capabilities,

							init_options = {
								bundles = bundles,
							},

							on_attach = function(client, bufnr)
								require("jdtls").setup_dap({ hotcodereplace = "auto" })
							end,
						})
						return
					end

					local server = servers[server_name] or {}
					server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
					require("lspconfig")[server_name].setup(server)
				end,
			},
		})

		local lint = require("lint")
		lint.linters_by_ft = {
			python = { "flake8" },
		}

		vim.api.nvim_create_autocmd({ "BufWritePost" }, {
			callback = function()
				lint.try_lint()
			end,
		})

		local format = require("lsp-format")
		format.setup({})

		vim.api.nvim_create_autocmd("LspAttach", {
			callback = function(args)
				if
					vim.bo[args.buf].filetype == "python"
					or vim.bo[args.buf].filetype == "go"
					or vim.bo[args.buf].filetype == "java"
					or vim.bo[args.buf].filetype == "rust"
				then
					vim.api.nvim_create_autocmd("BufWritePre", {
						buffer = args.buf,
						callback = function()
							vim.lsp.buf.format({ async = false })
						end,
					})
				end
			end,
		})
	end,
}

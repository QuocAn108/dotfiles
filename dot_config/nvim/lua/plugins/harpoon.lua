return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
	config = function()
		local harpoon = require("harpoon")
		harpoon:setup()

		-- Setup custom floating colors harmonized with TokyoNight
		local function setup_harpoon_highlights()
			local ok, tokyonight_colors = pcall(require, "tokyonight.colors")
			local colors = ok and tokyonight_colors.setup() or {}
			local bg = colors.bg_float or "#1e2030"
			local border = colors.border_highlight or colors.blue or "#7aa2f7"
			local title = colors.blue or "#82aaff"

			vim.api.nvim_set_hl(0, "HarpoonNormal", { bg = bg })
			vim.api.nvim_set_hl(0, "HarpoonBorder", { fg = border, bg = bg })
			vim.api.nvim_set_hl(0, "HarpoonTitle", { fg = title, bg = bg, bold = true })
			vim.api.nvim_set_hl(0, "HarpoonCursorLine", { bg = colors.bg_highlight or "#2d3149" })
		end

		setup_harpoon_highlights()

		-- Hook into Harpoon UI creation to apply custom styling
		harpoon:extend({
			UI_CREATE = function(cx)
				vim.api.nvim_set_option_value(
					"winhighlight",
					"Normal:HarpoonNormal,FloatBorder:HarpoonBorder,FloatTitle:HarpoonTitle,CursorLine:HarpoonCursorLine",
					{ win = cx.win_id }
				)
			end,
		})

		-- Dynamic Harpoon UI opener
		local function open_harpoon_menu()
			local list = harpoon:list()
			local count = list:length()
			local height = math.max(3, math.min(count + 1, 8))

			harpoon.ui:toggle_quick_menu(list, {
				border = "rounded",
				title_pos = "center",
				title = " 󰛢 Harpoon Marks ",
				ui_width_ratio = 0.38,
				ui_max_width = 56,
				height_in_lines = height,
			})
		end

		-- Telescope picker for Harpoon
		local function open_harpoon_telescope()
			local list = harpoon:list()
			local file_paths = {}
			for _, item in ipairs(list.items) do
				table.insert(file_paths, item.value)
			end

			local themes = require("telescope.themes")
			local pickers = require("telescope.pickers")
			local finders = require("telescope.finders")
			local conf = require("telescope.config").values

			pickers
				.new(themes.get_dropdown({
					previewer = false,
					prompt_title = "󰛢 Harpoon Marks",
					finder = finders.new_table({
						results = file_paths,
					}),
					sorter = conf.generic_sorter({}),
				}))
				:find()
		end

		-- Keymaps
		vim.keymap.set("n", "<leader>ha", function()
			harpoon:list():add()
			vim.notify("📌 Harpoon: Pinned " .. vim.fn.expand("%:t"), vim.log.levels.INFO)
		end, { desc = "[H]arpoon: [A]dd / Pin current file" })

		vim.keymap.set("n", "<leader>hh", open_harpoon_menu, { desc = "[H]arpoon: Open quick menu" })
		vim.keymap.set("n", "<C-e>", open_harpoon_menu, { desc = "Toggle Harpoon Menu" })
		vim.keymap.set("n", "<leader>hs", open_harpoon_telescope, { desc = "[H]arpoon: [S]earch marks in Telescope" })
		vim.keymap.set("n", "<leader>fh", open_harpoon_telescope, { desc = "[F]ind [H]arpoon marks" })

		-- Quick file jumping
		vim.keymap.set("n", "<leader>1", function()
			harpoon:list():select(1)
		end, { desc = "Harpoon: Go to file 1" })

		vim.keymap.set("n", "<leader>2", function()
			harpoon:list():select(2)
		end, { desc = "Harpoon: Go to file 2" })

		vim.keymap.set("n", "<leader>3", function()
			harpoon:list():select(3)
		end, { desc = "Harpoon: Go to file 3" })

		vim.keymap.set("n", "<leader>4", function()
			harpoon:list():select(4)
		end, { desc = "Harpoon: Go to file 4" })
	end,
}

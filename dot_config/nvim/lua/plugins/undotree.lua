return {
	"mbbill/undotree",
	cmd = "UndotreeToggle",
	keys = {
		{ "<leader>u", "<cmd>UndotreeToggle<cr>", desc = "Toggle [U]ndotree (Timeline)" },
	},
	config = function()
		vim.g.undotree_WindowLayout = 2 
		vim.g.undotree_SetFocusWhenToggle = 1
		vim.g.undotree_ShortIndicators = 1
		vim.g.undotree_DiffpanelHeight = 10
	end,
}

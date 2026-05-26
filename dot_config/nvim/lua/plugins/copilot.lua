return {
	"github/copilot.vim",
	lazy = false,
	config = function()
		-- Phím tắt để chấp nhận gợi ý của Copilot (Mặc định là <Tab>)
		-- Nếu sợ trùng với blink.cmp, bạn có thể đổi thành <C-l> hoặc giữ nguyên tùy ý
		vim.g.copilot_no_tab_map = true
		vim.keymap.set("i", "<C-l>", 'copilot#Accept("<CR>")', {
			expr = true,
			replace_keycodes = false,
		})
	end,
}

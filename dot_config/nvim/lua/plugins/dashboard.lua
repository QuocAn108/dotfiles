return {
  'glepnir/dashboard-nvim',
  event = 'VimEnter',
  config = function()
    local dashboard = require 'dashboard'

    -- Icons
    local ui_icons = {
      ft = vim.g.have_nerd_font and '' or '📂',
      config = vim.g.have_nerd_font and '' or '🛠',
      event = vim.g.have_nerd_font and '' or '📅',
      source = vim.g.have_nerd_font and '' or '📄',
      task = vim.g.have_nerd_font and '' or '📌',
    }

    dashboard.setup {
      theme = 'hyper',
      config = {
        week_header = {
          enable = true,
        },
        shortcut = {
          { desc = ' ' .. ui_icons.ft .. ' Tìm kiếm tệp', group = '@property', action = 'Telescope find_files', key = 'f' },
          { desc = ' ' .. ui_icons.source .. ' Tạo tệp mới', group = '@property', action = 'enew', key = 'n' },
          { desc = ' ' .. ui_icons.event .. ' Tệp gần đây', group = '@property', action = 'Telescope oldfiles', key = 'r' },
          { desc = ' ' .. ui_icons.config .. ' Cấu hình', group = '@property', action = 'e ~/.config/nvim', key = 'c' },
          { desc = ' ' .. ui_icons.task .. ' Thoát Neovim', group = '@property', action = 'qa', key = 'q' },
        },
      },
    }
  end,
}

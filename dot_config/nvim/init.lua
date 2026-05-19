-- File: init.lua

-- [[ Thiết lập biến toàn cục ]]
-- Các biến này cần được khai báo đầu tiên để các file khác có thể sử dụng.

-- Set <space> as the leader key
-- See `:help mapleader`
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- [[ Thiết lập cấu hình lõi ]]
-- Tải các tùy chọn và keymaps cơ bản
require 'core.options'
require 'core.keymaps'
require 'core.snippets'
-- Install package manager
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

---@type table
local rtp = vim.opt.rtp
rtp:prepend(lazypath)

require('lazy').setup('plugins', {})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et

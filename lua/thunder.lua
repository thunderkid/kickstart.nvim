
-- ~/.config/nvim/lua/myconfig.lua
local M = {}

M.setup = function()
  -- Your setup code here

-- thunderstuff
vim.opt.nu = true 
vim.opt.relativenumber = true

vim.opt.hlsearch = false

-- vim.keymap.set("n", "<leader>nt", vim.cmd.Neotree)
vim.keymap.set("n", "<leader>ts", "<CMD>Neotree close<CR><CMD>Neotree reveal<CR>", { desc = 'Neotree sidebar' }) 
vim.keymap.set("n", "<leader>tw", "<CMD>Neotree close<CR><CMD>Neotree reveal current<CR>", { desc = 'Neotree full width' }) 
vim.keymap.set("n", "<leader>tt", "<CMD>Neotree toggle<CR>") 
vim.keymap.set("n", "<leader>tq", "<CMD>Neotree close<CR>") 
-- vim.keymap.set("n", "<leader>tr", "<CMD>Neotree reveal<CR>")
-- vim.keymap.set("n", "<leader>tw", "<CMD>Neotree reveal current<CR>")

local function generate_file_info()
    local path = vim.fn.expand('%:p')
    local size = vim.fn.getfsize(vim.fn.expand('%'))
    local last_modified = vim.fn.strftime('%c', vim.fn.getftime(vim.fn.expand('%')))
    local filetype = vim.bo.filetype
    local fileencoding = vim.bo.fileencoding

    return {
        "Path: " .. path,
        "Size: " .. size .. " bytes",
        "Last Modified: " .. last_modified,
        "Filetype: " .. filetype,
        "Encoding: " .. fileencoding
    }
end

local function display_in_floatwin(info_lines)
    -- Determine window size
    local win_height = #info_lines
    local win_width = 0
    for _, line in ipairs(info_lines) do
        win_width = math.max(win_width, #line)
    end

    -- Center the floating window
    local row = math.floor((vim.o.lines - win_height) / 2)
    local col = math.floor((vim.o.columns - win_width) / 2)

    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, info_lines)

    local win_id = vim.api.nvim_open_win(buf, true, {
        relative = "editor",
        row = row,
        col = col,
        width = win_width,
        height = win_height,
        style = "minimal"
    })

    -- Close the floating window with 'q'
    vim.api.nvim_buf_set_keymap(buf, 'n', 'q', ':bw!<CR>', { noremap = true, silent = true })
end

local function show_file_info()
    local info_lines = generate_file_info()
    display_in_floatwin(info_lines)
end

vim.keymap.set('n', '<leader>fi', show_file_info, { desc = '[F]iley [I]nfo' })


local function open_terminal_in_current_file_dir()
    -- Get the directory of the current file
    local dir = vim.fn.expand('%:p:h')
    vim.cmd('cd ' .. dir)
    vim.cmd('term')
end

-- 2. Set the key binding to call the Lua function
vim.keymap.set('n', '<leader>tc', open_terminal_in_current_file_dir, { noremap = true, silent = true, desc = 'Open terminal in current file directory' })


local function open_in_vscode()
    local filename = vim.fn.expand('%:p') -- get the full path of the current file
    vim.cmd('!code ' .. filename)
end

local function open_tmux_pane_in_current_file_dir()
    
    local dir = vim.fn.expand('%:p:h')
    local tmux_cmd = "tmux split-window -h -c " .. dir
             vim.cmd('silent !' .. tmux_cmd) -- Run the tmux command
end 

vim.keymap.set('n', '<leader>tv', open_in_vscode, { noremap = true, silent = true, desc =  'Open current file in VSCode' })
vim.keymap.set('n', '<leader>tm', open_tmux_pane_in_current_file_dir, { noremap = true, silent = true, desc =  'Open tmux pane at current directory' })

print("ThunderConfiguration 0.2 reloaded at: " .. os.date("%Y-%m-%d %H:%M:%S"))
-- /thunderstuff



end

return M



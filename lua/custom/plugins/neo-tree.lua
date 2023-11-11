-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information

-- Unless you are still migrating, remove the deprecated commands from v1.x
vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])

return {
  "nvim-neo-tree/neo-tree.nvim",
  version = "*",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
    "MunifTanjim/nui.nvim",
  },
  config = function ()
    require('neo-tree').setup {
      default_component_configs = {
        symlink_target = {
          enabled = true
        }
      },

      filesystem = {
        -- change synchronization bindings so that changing root in tree changes the current dir in neovim.
        -- this makes sf for fuzzy search etc just apply to the root shown in neotree
        -- see https://github.com/nvim-neo-tree/neo-tree.nvim/blob/main/doc/neo-tree.txt
        bind_to_cwd = true, -- true creates a 2-way binding between vim's cwd and neo-tree's root
        cwd_target = {
          sidebar = "global",   -- sidebar is when position = left or right
          current = "global" -- current is when position = current
        },

        window = {
          mappings = {
            ["b"] = {
              function(state)
                local node = state.tree:get_node()

                local folder_name = node.type == 'directory' and node.path or (node.path:match("(.*%/).*") or "")
                --              print(node.type, node.path, folder_name)
                local tmux_cmd = "tmux split-window -h -c " .. folder_name
                vim.cmd('silent !' .. tmux_cmd) -- Run the tmux command
              end,
              desc = 'open tmux pane at folder'
            },
            ["u"] = {
              function(state)
                local node = state.tree:get_node()
                vim.cmd('silent !code ' .. node.path)
              end
            }
          }
        }
      }
    }
  end,
}

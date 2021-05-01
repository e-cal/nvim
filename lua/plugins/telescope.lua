local actions = require('telescope.actions')
require('telescope').setup {
    defaults = {
        file_sorter = require('telescope.sorters').get_fzy_sorter,
        prompt_prefix = '   ',
        selection_caret = ' ',
        color_devicons = true,

        file_previewer   = require('telescope.previewers').vim_buffer_cat.new,
        grep_previewer   = require('telescope.previewers').vim_buffer_vimgrep.new,
        qflist_previewer = require('telescope.previewers').vim_buffer_qflist.new,

        mappings = {
            i = {
                ["<C-x>"] = false,
                ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
                ["<esc>"] = actions.close,
				["<CR>"] = actions.select_default + actions.center,
                ["<C-j>"] = actions.move_selection_next,
                ["<C-k>"] = actions.move_selection_previous,
            }
        }
    },
    extensions = {
        fzy_native = {
            override_generic_sorter = false,
            override_file_sorter = true,
        },
        media_files = {
            filetypes = {"png", "webp", "jpg", "jpeg", "mp4", "pdf"},
            find_cmd = "rg"
        }
    }
}

require('telescope').load_extension('fzy_native')
require('telescope').load_extension('media_files')

local M = {}
M.search_dotfiles = function()
    require("telescope.builtin").find_files({
        prompt_title = " Config ",
        cwd = "$HOME/.config/nvim",
    })
end

M.git_branches = function()
    require("telescope.builtin").git_branches({
        attach_mappings = function(_, map)
            map('i', '<c-d>', actions.git_delete_branch)
            map('n', '<c-d>', actions.git_delete_branch)
            return true
        end
    })
end

return M

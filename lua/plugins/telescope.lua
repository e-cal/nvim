local actions = require("telescope.actions")

require("telescope").setup {
    defaults = {
        vimgrep_arguments = {
            "rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case"
        },
        file_sorter = require("telescope.sorters").get_fzy_sorter,
        prompt_prefix = "   ",
        selection_caret = " ",
        color_devicons = true,
        file_previewer = require("telescope.previewers").vim_buffer_cat.new,
        grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
        qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
        mappings = {
            i = {
                ["<C-x>"] = false,
                ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
                ["<esc>"] = actions.close,
                ["<CR>"] = actions.select_default + actions.center,
                ["<C-j>"] = actions.move_selection_next,
                ["<C-k>"] = actions.move_selection_previous
            }
        }
    },
    pickers = {
        file_browser = {path_display = {}},
        grep_string = {path_display = {"tail"}},
        find_files = {hidden = true, no_ignore = true}
    },
    extensions = {
        fzy_native = {
            override_generic_sorter = true,
            override_file_sorter = true
        },
        media_files = {
            filetypes = {"png", "webp", "jpg", "jpeg", "mp4", "pdf"},
            find_cmd = "rg"
        }
    }
}

require("telescope").load_extension("fzy_native")
require("telescope").load_extension("media_files")
require("telescope").load_extension("file_browser")

local M = {}

M.git_branches = function()
    require("telescope.builtin").git_branches(
        {
            attach_mappings = function(_, map)
                map("i", "<c-d>", actions.git_delete_branch)
                map("n", "<c-d>", actions.git_delete_branch)
                return true
            end
        }
    )
end

M.search_dotfiles = function()
    require("telescope.builtin").find_files(
        {prompt_title = " Config ", cwd = "$DOTFILES/.config/nvim"}
    )
end

M.search_dir = function()
    local dir = vim.fn.input("Search from: ")
    if (dir ~= "" and dir ~= nil) then
        require("telescope.builtin").find_files(
            {prompt_title = string.format(" Searching %s ", dir), cwd = dir}
        )
    else
        require("telescope.builtin").find_files()
    end
end

return M

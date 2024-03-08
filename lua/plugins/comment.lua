return {
    "numToStr/Comment.nvim",
    event = "VeryLazy",
    config = function()
        require("Comment").setup()
        vim.api.nvim_set_keymap("v", "<C-_>", "gc", {})
    end,
}

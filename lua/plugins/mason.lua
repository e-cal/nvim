return {
    "williamboman/mason-lspconfig.nvim",
    event = "VeryLazy",
    dependencies = {
        { "williamboman/mason.nvim", build = ":MasonUpdate" },
    },
}

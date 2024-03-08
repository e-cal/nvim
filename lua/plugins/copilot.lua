return {
    {
        "zbirenbaum/copilot-cmp",
        event = "VeryLazy",
        dependencies = {
            {
                "zbirenbaum/copilot.lua",
                opts = {
                    suggestion = { enabled = false },
                    panel = { enabled = false },
                },
            },
        },
        opts = {},
    },
}

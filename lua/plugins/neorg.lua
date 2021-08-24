require('neorg').setup {
    load = {
        ["core.defaults"] = {}, -- Load all the default modules
        ["core.norg.concealer"] = {}, -- Allows for use of icons
        ["core.norg.dirman"] = { -- Manage your directories with Neorg
            config = {workspaces = {my_workspace = "~/neorg"}}
        }
    }
}


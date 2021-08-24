require('neorg').setup {
    load = {
        ["core.defaults"] = {}, -- Load all the default modules
        ["core.norg.concealer"] = {
            config = {
                icons = {
                    todo = {
                        enabled = true, -- Conceal TODO items

                        done = {
                            enabled = true, -- Conceal whenever an item is marked as done
                            icon = ""
                        },
                        pending = {
                            enabled = true, -- Conceal whenever an item is marked as pending
                            icon = ""
                        },
                        undone = {
                            enabled = true, -- Conceal whenever an item is marked as undone
                            icon = "×"
                        }
                    },
                    quote = {
                        enabled = true, -- Conceal quotes
                        icon = "∣"
                    },
                    heading = {
                        enabled = true, -- Enable beautified headings

                        -- Define icons for all the different heading levels
                        level_1 = {enabled = true, icon = ""},

                        level_2 = {enabled = true, icon = ""},

                        level_3 = {enabled = true, icon = ""},

                        level_4 = {enabled = true, icon = ""}
                    },
                    marker = {
                        enabled = true, -- Enable the beautification of markers
                        icon = ""
                    }
                }
            }
        }, -- Allows for use of icons
        ["core.norg.dirman"] = { -- Manage your directories with Neorg
            config = {workspaces = {my_workspace = "~/neorg"}}
        }
    }
}


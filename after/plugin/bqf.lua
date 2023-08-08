require("bqf").setup({
  auto_resize_height = false,
  filter = {
    fzf = {
      action_for = {
        ["ctrl-c"] = "closeall",
        ["ctrl-q"] = "signtoggle",
        ["ctrl-t"] = "tabedit",
        ["ctrl-v"] = "vsplit",
        ["ctrl-x"] = "split"
      },
      extra_opts = { "--bind", "ctrl-o:toggle-all" }
    }
  },
  func_map = {
    drop = "O",
    filter = "zn",
    filterr = "zN",
    fzffilter = "zf",
    lastleave = "'\"",
    nextfile = "<C-n>",
    nexthist = ">",
    open = "<CR>",
    openc = "o",
    prevfile = "<C-p>",
    prevhist = "<",
    pscrolldown = "<C-f>",
    pscrollorig = "zo",
    pscrollup = "<C-b>",
    ptoggleauto = "P",
    ptoggleitem = "p",
    ptogglemode = "zp",
    sclear = "z<Tab>",
    split = "<C-x>",
    stogglebuf = "'<Tab>",
    stoggledown = "<Tab>",
    stoggleup = "<S-Tab>",
    stogglevm = "<Tab>",
    tab = "t",
    tabb = "T",
    tabc = "<C-t>",
    tabdrop = "",
    vsplit = "<C-v>"
  },
  magic_window = true,
  preview = {
    auto_preview = false,
    border = "rounded",
    buf_label = true,
    delay_syntax = 50,
    show_scroll_bar = true,
    show_title = true,
    win_height = 15,
    win_vheight = 15,
    winblend = 12,
    wrap = false
  },
  previous_winid_ft_skip = {}
})

--[[

--]]

return {
  'NickvanDyke/opencode.nvim',
  dependencies = { { 'folke/snacks.nvim', opts = { input = { enabled = true } } } },
  -- opts = {},
  keys = {
    --[[
    @buffer 	    Current buffer
    @buffers 	    Open buffers
    @cursor 	    Cursor position
    @selection 	    Selected text
    @visible 	    Visible text
    @diagnostic 	Current line diagnostics
    @diagnostics 	Current buffer diagnostics
    @quickfix 	    Quickfix list
    @diff 	        Git diff
    @grapple 	    grapple.nvim tags
    ]]
    { '<leader>aa', function() require('opencode').ask() end, desc = 'plain message', },
    { '<leader>a<cr>', function() require('opencode').ask('@grapple ') end, desc = 'message w/ context (grapple)', mode = 'n', },

    { '<leader>at', function() require('opencode').toggle() end, desc = 'toggle', },
    { '<leader>ae', function() require('opencode').prompt("Explain @cursor and its context") end, desc = "Explain code near cursor", },
    { '<leader>an', function() require('opencode').command('session_new') end, desc = 'New session', },
    { '<leader>ay', function() require('opencode').command('messages_copy') end, desc = 'Copy last message', },

    { '<leader>ap', function() require('opencode').select_prompt() end, desc = 'Select prompt', mode = { 'n', 'v', }, },
    { '<leader>aa', function() require('opencode').ask('@selection: ') end, desc = 'Ask opencode about selection', mode = 'v', },


    { '<S-C-u>',    function() require('opencode').command('messages_half_page_up') end, desc = 'Scroll messages up', },
    { '<S-C-d>',    function() require('opencode').command('messages_half_page_down') end, desc = 'Scroll messages down', },
  },
}

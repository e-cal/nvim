return {
  'NickvanDyke/opencode.nvim',
  dependencies = { { 'folke/snacks.nvim', opts = { input = { enabled = true } } } },
  -- opts = {},
  keys = {
    { '<leader>OA', function() require('opencode').ask() end, desc = 'Ask opencode', },
    { '<leader>Oa', function() require('opencode').ask('@cursor: ') end, desc = 'Ask opencode about this', mode = 'n', },
    { '<leader>Oa', function() require('opencode').ask('@selection: ') end, desc = 'Ask opencode about selection', mode = 'v', },
    { '<leader>Ot', function() require('opencode').toggle() end, desc = 'Toggle embedded opencode', },
    { '<leader>On', function() require('opencode').command('session_new') end, desc = 'New session', },
    { '<leader>Oy', function() require('opencode').command('messages_copy') end, desc = 'Copy last message', },
    { '<leader>Op', function() require('opencode').select_prompt() end, desc = 'Select prompt', mode = { 'n', 'v', }, },
    { '<leader>Oe', function() require('opencode').prompt("Explain @cursor and its context") end, desc = "Explain code near cursor", },
    { '<S-C-u>',    function() require('opencode').command('messages_half_page_up') end, desc = 'Scroll messages up', },
    { '<S-C-d>',    function() require('opencode').command('messages_half_page_down') end, desc = 'Scroll messages down', },
  },
}

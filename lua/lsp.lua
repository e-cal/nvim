local lsp = require("lsp-zero")

lsp.preset({ name = "recommended", set_lsp_keymaps = false, manage_nvim_cmp = true, suggest_lsp_servers = false })

lsp.ensure_installed({
	-- "tsserver",
	"rust_analyzer",
	"pyright",
	"lua_ls",
})

lsp.configure("lua_ls", {
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim" },
			},
		},
	},
})
lsp.setup()

local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- TODO: add on_attach to lsp-zero

-- auto show diagnostics in hover window
-- vim.cmd([[autocmd CursorHold,CursorHoldI * lua vim.lsp.diagnostic.show_line_diagnostics({focusable=false})]])

-- local function documentHighlight(client, bufnr)
-- 	-- Set autocommands conditional on server_capabilities
-- 	if client.server_capabilities.documentHighlightProvider then
-- 		vim.api.nvim_exec(
-- 			[[
--       hi LspReferenceRead cterm=bold ctermbg=red guibg=#464646
--       hi LspReferenceText cterm=bold ctermbg=red guibg=#464646
--       hi LspReferenceWrite cterm=bold ctermbg=red guibg=#464646
--       augroup lsp_document_highlight
--         autocmd! * <buffer>
--         autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
--         autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
--       augroup END
--     ]],
-- 			false
-- 		)
-- 	end
-- end
--
-- local lsp_config = {}
--
-- function lsp_config.common_on_attach(client, bufnr)
-- 	documentHighlight(client, bufnr)
-- end
--
-- lsp_config.show_vtext = true
--
-- lsp_config.toggle_vtext = function()
-- 	lsp_config.show_vtext = not lsp_config.show_vtext
-- 	vim.lsp.diagnostic.display(vim.lsp.diagnostic.get(0, 1), 0, 1, { virtual_text = lsp_config.show_vtext })
-- end
--
-- vim.api.nvim_exec('command! -nargs=0 LspVirtualTextToggle lua require("lsp").toggle_vtext()', false)
--
-- return lsp_config

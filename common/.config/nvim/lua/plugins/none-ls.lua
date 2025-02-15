return {
	"nvimtools/none-ls.nvim",
	config = function()
		local null_ls = require("null-ls")
		local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

		null_ls.setup({
			sources = {
				null_ls.builtins.formatting.stylua,
				null_ls.builtins.formatting.prettierd,
				null_ls.builtins.formatting.clang_format,
			},
			on_attach = function(client, bufnr)
				if client.supports_method("textDocument/formatting") then
					-- Clear any previous autocmds for this buffer in our group
					vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
					vim.api.nvim_create_autocmd("BufWritePre", {
						group = augroup,
						buffer = bufnr,
						callback = function()
							-- For Neovim 0.8 use: vim.lsp.buf.formatting_sync()
							-- For later versions, you can use:
							vim.lsp.buf.format({ async = false, bufnr = bufnr })
						end,
					})
				end
			end,
		})

		-- Optional: keymap to manually format on demand
		vim.keymap.set("n", "<leader>gf", function()
			vim.lsp.buf.format({ async = true })
		end, {})
	end,
}

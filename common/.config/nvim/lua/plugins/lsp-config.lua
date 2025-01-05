return {
	{
		"williamboman/mason.nvim",
		lazy = false,
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = { "lua_ls", "tsserver", "html", "marksman", "gopls", "tailwindcss", "denols" },
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			local lspconfig = require("lspconfig")

			-- Function to check if current workspace is part of Deno project
			local function is_deno_workspace()
				local cwd = vim.fn.getcwd()
				return lspconfig.util.root_pattern("deno.json", "import_map.json", "deno.jsonc")(cwd)
					or vim.fn.match(vim.fn.expand("%:p"), "/supabase/functions") > -1
			end

			-- Autocommand to dynamically switch between tsserver and denols
			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(event)
					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if client.name == "tsserver" and is_deno_workspace() then
						client.stop()
						return
					end
					-- Optionally, start denols if not running and it's a Deno workspace
					if not vim.lsp.get_active_clients({ name = "denols" }) and is_deno_workspace() then
						lspconfig.denols.setup({
							on_attach = on_attach,
							root_dir = function(fname)
								return fname and vim.fn.fnamemodify(fname, ":p:h")
							end,
							capabilities = require("cmp_nvim_lsp").default_capabilities(),
						})
					end
				end,
			})
			-- TypeScript LSP
			lspconfig.tsserver.setup({
				on_attach = on_attach,
				root_dir = lspconfig.util.root_pattern("package.json"),
				single_file_support = false,
				capabilities = capabilities,
			})

			-- Deno LSP
			lspconfig.denols.setup({
				on_attach = on_attach,
				root_dir = function(fname)
					-- Enable denols only within the supabase/functions directory
					if fname then
						local is_in_supabase = vim.fn.match(vim.fn.fnamemodify(fname, ":p"), "supabase/functions") > -1
						local has_deno_config =
							lspconfig.util.root_pattern("deno.json", "deno.jsonc", "import_map.json")(fname)
						if is_in_supabase or has_deno_config then
							return vim.fn.fnamemodify(fname, ":p:h")
						end
					end
				end,
				capabilities = capabilities,
				single_file_support = false,
			})

			lspconfig.marksman.setup({
				capabilities = capabilities,
			})
			lspconfig.html.setup({
				capabilities = capabilities,
			})
			lspconfig.lua_ls.setup({
				capabilities = capabilities,
			})
			lspconfig.gopls.setup({
				capabilities = capabilities,
			})
			lspconfig.tailwindcss.setup({
				capabilities = capabilities,
			})

			vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
			vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, {})
			vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, {})
			vim.keymap.set({ "n" }, "<leader>ca", vim.lsp.buf.code_action, {})
		end,
	},
}

return {
	"folke/trouble.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		-- Function to copy the current diagnostic message to the clipboard
		local function copy_diagnostic_message()
			local diagnostics = vim.diagnostic.get(0, { lnum = vim.fn.line(".") - 1 })
			if not diagnostics or #diagnostics == 0 then
				print("No diagnostic message found")
				return
			end
			local message = diagnostics[1].message
			vim.fn.setreg("+", message)
			print("Diagnostic message copied to clipboard")
		end

		-- Configuration for trouble.nvim
		vim.keymap.set("n", "<leader>xx", function()
			require("trouble").toggle()
		end)
		vim.keymap.set("n", "<leader>xw", function()
			require("trouble").toggle("workspace_diagnostics")
		end)
		vim.keymap.set("n", "<leader>xd", function()
			require("trouble").toggle("document_diagnostics")
		end)
		vim.keymap.set("n", "<leader>xq", function()
			require("trouble").toggle("quickfix")
		end)
		vim.keymap.set("n", "<leader>xl", function()
			require("trouble").toggle("loclist")
		end)
		vim.keymap.set("n", "gR", function()
			require("trouble").toggle("lsp_references")
		end)

		-- Additional key mappings for diagnostics using Trouble
		vim.keymap.set("n", "<leader>dn", function()
			require("trouble").next({ skip_groups = true, jump = true })
		end, { desc = "Go to next diagnostic" })
		vim.keymap.set("n", "<leader>dp", function()
			require("trouble").previous({ skip_groups = true, jump = true })
		end, { desc = "Go to previous diagnostic" })
		vim.keymap.set("n", "<leader>df", function()
			vim.diagnostic.open_float()
		end, { desc = "Open diagnostic float" })

		-- Key mapping to copy the diagnostic message to the clipboard
		vim.keymap.set("n", "<leader>dc", copy_diagnostic_message, { desc = "Copy diagnostic message to clipboard" })
	end,
}

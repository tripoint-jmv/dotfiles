return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"leoluz/nvim-dap-go",
			"rcarriga/nvim-dap-ui",
			"theHamsta/nvim-dap-virtual-text",
			"nvim-neotest/nvim-nio",
			"williamboman/mason.nvim",
		},
		config = function()
			local dap = require("dap")
			local ui = require("dapui")

			require("dapui").setup()
			require("dap-go").setup()
			require("nvim-dap-virtual-text").setup()

			-- Configure the codelldb adapter for C++ (and C)
			dap.adapters.codelldb = {
				type = "server",
				port = "${port}",
				executable = {
					command = "codelldb",
					args = { "--port", "${port}" },
					detached = false,
				},
			}

			-- Helper function: search candidate directories recursively for an ELF executable.
			local function find_executable()
				local cwd = vim.fn.getcwd()
				-- List of directories to search.
				local candidate_dirs = {
					cwd,
					cwd .. "/build",
					cwd .. "/builds",
					cwd .. "/bin",
					cwd .. "/out",
				}
				local executables = {}

				-- Iterate over each candidate directory.
				for _, dir in ipairs(candidate_dirs) do
					if vim.fn.isdirectory(dir) == 1 then
						-- Use the "find" command to recursively list executable files.
						local cmd = "find " .. vim.fn.shellescape(dir) .. " -type f -executable"
						local results = vim.fn.systemlist(cmd)
						for _, file in ipairs(results) do
							-- Use the "file" command to check if the file is an ELF binary.
							local file_info = vim.fn.system("file -b " .. vim.fn.shellescape(file))
							-- If the file info contains "ELF", consider it a valid candidate.
							if file_info:match("ELF") then
								table.insert(executables, file)
							end
						end
					end
				end

				-- If one or more executables were found, return the first one.
				if #executables > 0 then
					return executables[1]
				end

				-- Otherwise, return nil so we can prompt the user.
				return nil
			end

			-- Define debug configurations for C++ (and C)
			dap.configurations.cpp = {
				{
					name = "Launch file",
					type = "codelldb", -- Must match the adapter name.
					request = "launch",
					program = function()
						-- Attempt to auto-detect an executable.
						local exe = find_executable()
						if exe and exe ~= "" then
							return exe
						else
							-- Fallback: prompt the user for the executable path, defaulting to the project root.
							return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
						end
					end,
					cwd = "${workspaceFolder}",
					stopOnEntry = false,
					args = {},
				},
			}
			-- Use the same configuration for C files.
			dap.configurations.c = dap.configurations.cpp

			-- Key mappings
			vim.keymap.set("n", "<space>b", dap.toggle_breakpoint)
			vim.keymap.set("n", "<space>gb", dap.run_to_cursor)
			vim.keymap.set("n", "<space>?", function()
				ui.eval(nil, { enter = true })
			end)
			vim.keymap.set("n", "<F1>", dap.continue)
			vim.keymap.set("n", "<F2>", dap.step_into)
			vim.keymap.set("n", "<F3>", dap.step_over)
			vim.keymap.set("n", "<F4>", dap.step_out)
			vim.keymap.set("n", "<F5>", dap.step_back)
			vim.keymap.set("n", "<F13>", dap.restart)

			-- Automatically open/close the dap-ui when debugging starts/ends.
			dap.listeners.before.attach.dapui_config = function()
				ui.open()
			end
			dap.listeners.before.launch.dapui_config = function()
				ui.open()
			end
			dap.listeners.before.event_terminated.dapui_config = function()
				ui.close()
			end
			dap.listeners.before.event_exited.dapui_config = function()
				ui.close()
			end
		end,
	},
}

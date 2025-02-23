local config = require("gosigns.config")
local core = require("gosigns.core")

local api = vim.api

local M = {}

M.register_usercmds = function()
	api.nvim_create_user_command("GosignsEnable", M.enable, { desc = "Enable Gosings" })
	api.nvim_create_user_command("GosignsDisable", M.disable, { desc = "Disable Gosigns" })
	api.nvim_create_user_command("GosignsToggle", M.toggle, { desc = "Toggle Gosigns" })
end

M.register_autocmds = function()
	vim.api.nvim_create_autocmd({ "TextChanged", "InsertLeave", "LspAttach" }, {
		pattern = { "*.go" },
		callback = function(args)
			M.redraw(args.buf)
		end,
	})
end

M.setup = function(opts)
	config.setup(opts)
	core.setup()

	M.register_usercmds()
	M.register_autocmds()
end

M.enable = function()
	core.enable()
end

M.disable = function()
	core.disable()
end

M.toggle = function()
	core.toggle()
end

M.redraw = function(bufnr)
	core.redraw(bufnr)
end

return M

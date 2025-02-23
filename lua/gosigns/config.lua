local M = {}

---@class gosigns.OptsSignsChar
---@field public char string
---@field public hl string
local OptsSignsChar = {}

---@class gosigns.OptsSigns
---@field public priority integer
---@field public chars table<string, gosigns.OptsSignsChar>
local OptsSigns = {}

---@class gosigns.Opts
---@field public signs gosigns.OptsSigns
local defaults = {
	-- Config for signs in left-hand column
	signs = {
		-- https://neovim.io/doc/user/sign.html#sign-priority
		priority = 10,
		-- Config for chars by object types.
		-- To turn off the type set `nil` value
		chars = {
			-- Interfaces with implementations
			interface = {
				char = "↓",
				hl = "Comment",
			},
			-- Interface methods that have implementations
			method_elem = {
				char = "↓",
				hl = "Comment",
			},
			-- Structures that implement interfaces
			struct = {
				char = "↑",
				hl = "Comment",
			},
			-- Structures methods that implement interface methods
			method_declaration = {
				char = "↑",
				hl = "Comment",
			},
		},
	},
}

M.opts = defaults

---@param opts gosigns.Opts
M.setup = function(opts)
	M.opts = vim.tbl_deep_extend("force", M.opts, opts or {})
end

return M

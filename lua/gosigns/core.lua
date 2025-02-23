local config = require("gosigns.config")
local utils = require("gosigns.utils")

local M = {
	state = {
		enabled = true,
	},
	namespace = nil,
}

---@class gosigns.Node
---@field public type string
---@field public character integer
---@field public line integer
local Node = {}

M.setup = function()
	M.namespace = vim.api.nvim_create_namespace("gosigns")
end

M.enable = function()
	M.state.enabled = true
	local bufnr = vim.api.nvim_get_current_buf()
	M.redraw(bufnr)
end

M.disable = function()
	M.state.enabled = false
	M.clear()
end

M.toggle = function()
	if M.state.enabled then
		M.disable()
	else
		M.enable()
	end
end

--- @param bufnr integer
M.redraw = function(bufnr)
	if not M.state.enabled then
		return
	end

	local client = vim.lsp.get_clients({ name = "gopls" })[1]
	if not client then
		return
	end

	M.clear(bufnr)

	local nodes = utils.find_nodes(bufnr)

	for _, node in ipairs(nodes) do
		if
			node.type == "interface"
			or node.type == "method_elem"
			or node.type == "struct"
			or node.type == "method_declaration"
		then
			M.find_impl(client, node.line, node.character + 1, function(result)
				M.find_impl_callback(bufnr, node, result)
			end)
		end

		if node.type == "go_comment" then
			M.set_sign(bufnr, node)
		end
	end
end

--- @param bufnr integer
--- @param node gosigns.Node
--- @param result any
M.find_impl_callback = function(bufnr, node, result)
	if result == nil then
		return
	end

	M.set_sign(bufnr, node)
end

--- @param bufnr? integer
M.clear = function(bufnr)
	vim.api.nvim_buf_clear_namespace(bufnr or 0, M.namespace, 0, -1)
end

--- @param client vim.lsp.Client
--- @param line integer
--- @param character integer
--- @param callback_fn fun(result: any)
M.find_impl = function(client, line, character, callback_fn)
	client.request("textDocument/implementation", {
		textDocument = vim.lsp.util.make_text_document_params(),
		position = {
			line = line,
			character = character,
		},
	}, function(err, result)
		if err then
			return
		end
		callback_fn(result)
	end)
end

--- @param bufnr integer
--- @param node gosigns.Node
M.set_sign = function(bufnr, node)
	local sign = config.opts.signs.chars[node.type]
	vim.api.nvim_buf_set_extmark(bufnr, M.namespace, node.line, 0, {
		id = node.line + 1, -- Must be positive integer
		sign_text = sign.char or "",
		sign_hl_group = sign.hl or "",
		priority = config.opts.signs.priority,
	})
end

return M

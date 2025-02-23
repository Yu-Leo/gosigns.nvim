local config = require("gosigns.config")

local M = {}

--- @param bufnr integer
--- @return table<gosigns.Node>
M.find_nodes = function(bufnr)
	local ok, parser = pcall(vim.treesitter.get_parser, bufnr, "go")
	if not ok then
		return {}
	end

	local root = parser:parse()[1]:root()
	local query = M.get_ts_query()
	local nodes = {}

	for id, node in query:iter_captures(root, 0) do
		local type = query.captures[id]
		local line, character = node:range()
		table.insert(nodes, {
			line = line,
			character = character,
			type = type,
		})
	end

	return nodes
end

---@return vim.treesitter.Query
M.get_ts_query = function()
	local query = ""

	if config.opts.signs.chars["interface"] ~= nil then
		query = query .. [[
      (type_spec
      name: (type_identifier) @interface
      type: (interface_type))
      ]]
	end

	if config.opts.signs.chars["struct"] ~= nil then
		query = query .. [[
    (type_spec
      name: (type_identifier) @struct
      type: (struct_type))
    ]]
	end

	if config.opts.signs.chars["method_elem"] ~= nil then
		query = query .. [[
    (method_elem
      name: (field_identifier) @method_elem)
    ]]
	end

	if config.opts.signs.chars["method_declaration"] ~= nil then
		query = query .. [[
    (method_declaration
      name: (field_identifier) @method_declaration)
    ]]
	end

	return vim.treesitter.query.parse("go", query)
end

return M

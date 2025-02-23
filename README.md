# gosigns.nvim

Neovim plugin that visualizes the implementations of **Go** structures, interfaces, and methods.

## ✨ Features

- Visualizes interfaces with implementations
- Visualizes interface methods that have implementations
- Visualizes structures that implement interfaces
- Visualizes methods of structures that implement interface methods
- Highly customizable plugin

## 📦 Installation

Install the plugin with your preferred package manager:

### [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
    "Yu-Leo/gosigns.nvim",
    ft = "go",
    cmd = {"GosignsEnable", "GosignsDisable", "GosignsToggle"},
    opts = {}, -- for default options. Refer to the configuration section for custom setup.
}
```

## ⚡️ Requirements

- LSP with the `gopls` server
  - for the `textDocument/implementations` request
- [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter/) with the `go` parser installed
    - to search for structures, interfaces, and methods

## ⚙️ Configuration

### Setup

<details><summary>Default Settings</summary>

```lua
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
```

</details>

## 🚀 Usage

### Commands

- `:GosignsEnable` - Enable gosigns
- `:GosignsDisable` - Disable gosigns
- `:GosignsToggle` - Toggle gosigns

### API

```lua
-- Enable gosigns
require("gosigns").enable()

-- Disable gosigns
require("gosigns").disable()

-- Toggle gosigns
require("gosigns").toggle()

-- Redraw gosigns for bufnr
require("gosigns").redraw(bufnr)
```

Check out [my neovim configuration](https://github.com/Yu-Leo/nvim).

## 🤝 Contributing

PRs and Issues are always welcome.

Author: [@Yu-Leo](https://github.com/Yu-Leo)

## 🫶 Alternatives

### [maxandron/goplements.nvim](https://github.com/maxandron/goplements.nvim)

Visualizes Go struct and interface implementations to the right of the definition.

It was taken as the basis of my plugin. I express my gratitude to [@maxandron](https://github.com/maxandron).

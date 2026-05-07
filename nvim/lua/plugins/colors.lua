return {
  {
    "folke/tokyonight.nvim",
    enabled = false,
    opts = {
      transparent = true,
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
      style = "night",
    },
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    enabled = true,
    priority = 1000,
    lazy = false,
    config = function()
      require("catppuccin").setup({
        flavour = "auto", -- or latte, frappe, macchiato
        transparent_background = true,
        show_end_of_buffer = false,
        integrations = {
          cmp = true,
          nvimtree = true,
          treesitter = true,
          telescope = {
            enabled = true,
            style = nil,
          },
        },
        styles = {
          comments = { "italic" },
          conditionals = { "italic" },
          -- floats = "transparent",
        },
        custom_highlights = function(colors)
          return {
            Normal = { bg = "NONE" },
            NormalNC = { bg = "NONE" },
            CursorLine = { bg = "NONE" },
            SignColumn = { bg = "NONE" },
            LineNr = { bg = "NONE" },
            CursorLineNr = { bg = "NONE" },
            EndOfBuffer = { bg = "NONE" },
            NormalFloat = { bg = "NONE" },
            FloatBorder = { bg = "NONE" },
            Pmenu = { bg = "NONE" },
            PmenuSel = { bg = "NONE", fg = colors.pink },
            WinSeparator = { bg = "NONE" },
          }
        end,
      })

      vim.cmd.colorscheme("catppuccin")

      vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "catppuccin*",
        callback = function()
          local groups = {
            "Normal", "NormalNC", "NormalFloat", "FloatBorder",
            "SignColumn", "LineNr", "CursorLineNr", "CursorLine",
            "EndOfBuffer", "Pmenu", "WinSeparator",
          }
          for _, group in ipairs(groups) do
            vim.api.nvim_set_hl(0, group, { bg = "NONE" })
          end
        end,
      })
    end,
  },

  {
    "scottmckendry/cyberdream.nvim",
    opts = {
      transparent = true,
      enabled = false,
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
      italic_comments = true,
    },
  },

  {
    "luisiacc/gruvbox-baby",
    config = function()
      vim.g.gruvbox_baby_transparent_mode = 1
      -- vim.g.gruvbox_baby_function_style = "strikethrough"
    end,
  },

  {
    "egerhether/heatherfield.nvim",
    opts = {
      transparent_background = true,
      custom_highlights = {
        StatusLine = { bg = "NONE", fg = "NONE" },
      },
    },
  },

  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
      defaults = {
        keymaps = false,
      },
    },
  },
}

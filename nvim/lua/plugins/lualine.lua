return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "marko-cerovac/material.nvim" },
  config = function()
    local icons = LazyVim.config.icons

    local git_user_cache = {}
    local function get_git_user()
      local cwd = vim.fn.getcwd()
      if git_user_cache[cwd] ~= nil then
        return git_user_cache[cwd]
      end
      if vim.fn.isdirectory(cwd .. "/.git") == 0 then
        git_user_cache[cwd] = ""
        return ""
      end
      local handle = io.popen("git config user.name 2>/dev/null")
      if not handle then
        git_user_cache[cwd] = ""
        return ""
      end
      local name = handle:read("*l")
      handle:close()
      local result = (name and name ~= "") and string.format("%-25s", "  Git User - " .. name) or ""
      git_user_cache[cwd] = result
      return result
    end

    vim.api.nvim_create_autocmd("DirChanged", {
      callback = function()
        git_user_cache = {}
      end,
    })

    require("lualine").setup({
      options = {
        theme = "material-stealth",
        globalstatus = true, -- Single statusline like VSCode
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        disabled_filetypes = { statusline = { "alpha", "dashboard", "starter" }, winbar = { "alpha", "dashboard", "starter" } },
      },

      sections = {
        -- Far left: Mode (like original config)
        lualine_a = {
          {
            "mode",
            icon = "",
            padding = { left = 1, right = 1 },
          },
        },

        -- Left side: Branch, diagnostics, folder (VSCode bottom-left style)
        lualine_b = {
          {
            "branch",
            icon = "",
            padding = { left = 1, right = 1 },
          },
          {
            "diagnostics",
            symbols = {
              error = icons.diagnostics.Error .. " ",
              warn = icons.diagnostics.Warn .. " ",
              info = icons.diagnostics.Info .. " ",
              hint = icons.diagnostics.Hint .. " ",
            },
            padding = { left = 1, right = 1 },
          },
          {
            function()
              return "|"
            end,
            padding = { left = 1, right = 1 },
          },
          {
            function()
              return " " .. " " .. vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
            end,
            padding = { left = 1, right = 2 },
          },
        },

        -- Center-left: Recording indicator + File status
        lualine_c = {
          {
            function()
              local reg = vim.fn.reg_recording()
              if reg == "" then
                return ""
              else
                return "Recording @" .. reg
              end
            end,
            padding = { left = 1, right = 1 },
          },
          {
            function()
              if vim.fn.empty(vim.fn.expand("%:t")) == 1 or vim.bo.buftype ~= "" then
                return ""
              end
              if vim.bo.modified then
                return "● Unsaved changes"
              elseif vim.bo.readonly then
                return "󰌾 Read-only"
              end
              return ""
            end,
            padding = { left = 1, right = 1 },
          },
        },

        -- Right side: File info, cursor position (VSCode bottom-right style)
        lualine_x = {
          {
            function()
              return get_git_user()
            end,
            icon = nil,
            padding = { left = 2, right = 2 },
          },
          {
            function()
              local buffers = vim.fn.len(vim.fn.filter(vim.fn.range(1, vim.fn.bufnr("$")), "buflisted(v:val)"))
              if vim.bo.buftype ~= "terminal" and vim.fn.empty(vim.fn.expand("%:t")) == 0 then
                return "󰓩 " .. " " .. buffers .. " buffer(s)"
              end
              return ""
            end,
            padding = { left = 2, right = 2 },
          },
          {
            function()
              if vim.bo.buftype ~= "" or vim.fn.empty(vim.fn.expand("%:t")) == 1 then
                return ""
              end
              return vim.bo.fileencoding ~= "" and vim.bo.fileencoding or vim.o.encoding
            end,
            padding = { left = 1, right = 1 },
          },
          {
            function()
              local devicons = require("nvim-web-devicons")
              local fname = vim.fn.bufname()
              local ext = vim.fn.fnamemodify(fname, ":e")

              local icon, _ = devicons.get_icon(fname, ext, { default = true })

              if icon == nil then
                return vim.bo.filetype
              end

              return icon .. "  " .. vim.bo.filetype
            end,
            padding = { left = 2, right = 2 },
          },
          {
            function()
              local os = jit.os
              if os == "OSX" then
                return "󰘳  MacOS" -- macOS
              elseif os == "Linux" then
                return "  Linux" -- Linux
              elseif os == "Windows" then
                return "󰍲  Windows" -- Windows
              end
            end,
            padding = { left = 1, right = 1 },
          },
          {
            function()
              local file = vim.fn.expand("%:p")
              if file == "" or vim.bo.buftype ~= "" then
                return ""
              end
              local size = vim.fn.getfsize(file)
              if size == -1 or size == -2 then
                return ""
              end

              local suffixes = { "B", "KB", "MB", "GB" }
              local i = 1
              while size > 1024 and i < #suffixes do
                size = size / 1024
                i = i + 1
              end
              return string.format("%.1f%s", size, suffixes[i])
            end,
            padding = { left = 1, right = 1 },
          },
        },

        -- Far right: Line/column position
        lualine_y = {
          {
            function()
              return string.format("Ln %d, Col %d", vim.fn.line("."), vim.fn.col("."))
            end,
            padding = { left = 1, right = 1 },
          },
        },

        -- Clock (your current feature)
        lualine_z = {
          {
            function()
              return "󱫒 " .. vim.fn.strftime("%H:%M")
            end,
            padding = { left = 1, right = 1 },
          },
        },
      },

      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "filename" },
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {},
      },

      winbar = {
        lualine_c = {
          {
            "filename",
            path = 1, -- Show relative path
            symbols = {
              modified = " ●",
              readonly = " ",
              unnamed = "",
            },
            padding = 1,
            cond = function()
              return vim.fn.empty(vim.fn.expand("%:t")) ~= 1 and vim.bo.buftype == ""
            end,
          },
        },
      },

      inactive_winbar = {
        lualine_c = {
          {
            "filename",
            path = 1,
            padding = 1,
          },
        },
      },
    })

    -- Global statusline
    vim.cmd([[set laststatus=3]])

    -- Update statusline immediately when recording starts/stops
    vim.api.nvim_create_autocmd({ "RecordingEnter", "RecordingLeave" }, {
      callback = function()
        vim.schedule(function()
          vim.cmd("redrawstatus")
        end)
      end,
    })
  end,
}

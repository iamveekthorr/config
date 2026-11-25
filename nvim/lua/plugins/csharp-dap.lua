-- Extends the lazyvim dotnet extra with auto-discovery and attach support.
-- The dotnet extra already registers the netcoredbg adapter and a basic Launch config.
return {
  {
    "mfussenegger/nvim-dap",
    optional = true,
    config = function()
      local dap = require("dap")

      -- Replace the default single Launch config with smarter ones
      dap.configurations.cs = {
        {
          type = "netcoredbg",
          name = "Launch (auto-detect dll)",
          request = "launch",
          program = function()
            local cwd = vim.fn.getcwd()
            local default = cwd .. "/bin/Debug/"
            local files = vim.fn.glob(default .. "**/*.dll", false, true)
            -- filter out .runtimeconfig and .deps files
            files = vim.tbl_filter(function(f)
              return not f:match("%.runtimeconfig%.dll") and not f:match("%.deps%.dll")
            end, files)
            if #files == 1 then
              return files[1]
            end
            return vim.fn.input("Path to dll: ", default, "file")
          end,
          cwd = "${workspaceFolder}",
          stopAtEntry = false,
          env = { ASPNETCORE_ENVIRONMENT = "Development" },
          console = "integratedTerminal",
        },
        {
          type = "netcoredbg",
          name = "Attach to process",
          request = "attach",
          processId = function()
            return require("dap.utils").pick_process()
          end,
        },
      }

      -- Apply the same configs to fsharp and vb
      dap.configurations.fsharp = dap.configurations.cs
      dap.configurations.vb = dap.configurations.cs
    end,
  },

  -- Inline variable values while stepping
  {
    "theHamsta/nvim-dap-virtual-text",
    optional = true,
    opts = { virt_text_pos = "eol" },
  },
}

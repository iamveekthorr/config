local exclude_locs = { "node_modules", ".next", "dist", ".git" }
local lockfiles = {
  "yarn.lock",
  "pnpm-lock.yaml",
  "package-lock.json",
}

return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    dashboard = {
      enabled = false,
      preset = {
        header = [[
███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝

          The hyperextensible Vim-based editor
]],
        keys = {
          { icon = "󰈔 ", key = "e", desc = "New File", action = ":ene | startinsert" },
          {
            icon = "󰱼 ",
            key = "f",
            desc = "Find File",
            action = function()
              require("snacks").picker.files({ root = false })
            end,
          },
          {
            icon = " ",
            key = "g",
            desc = "Find Word",
            action = function()
              require("snacks").picker.grep({ root = false })
            end,
          },
          {
            icon = "󰔟 ",
            key = "r",
            desc = "Recent Files",
            action = function()
              require("snacks").picker.recent({ filter = { cwd = true } })
            end,
          },
          {
            icon = "󰙰 ",
            key = "s",
            desc = "Restore Session",
            action = function()
              require("persistence").load()
            end,
          },
          {
            icon = " ",
            key = "x",
            desc = "File Explorer",
            action = function()
              require("snacks").explorer({ cwd = LazyVim.root() })
            end,
          },
          { icon = " ", key = "c", desc = "Configuration", action = ":edit $MYVIMRC" },
          { icon = "󰈆 ", key = "q", desc = "Quit", action = ":qa" },
        },
      },
      sections = {
        { section = "header" },
        { section = "keys", gap = 1, padding = 1 },
        {
          section = "terminal",
          cmd = "fortune -s | cowsay",
          height = 8,
          padding = 1,
          enabled = function()
            -- Only show if fortune and cowsay are installed
            return vim.fn.executable("fortune") == 1 and vim.fn.executable("cowsay") == 1
          end,
        },
        function()
          local quotes = {
            "Code is like humor. When you have to explain it, it's bad. - Cory House",
            "First, solve the problem. Then, write the code. - John Johnson",
            "Experience is the name everyone gives to their mistakes. - Oscar Wilde",
            "Knowledge is power. - Francis Bacon",
            "Code never lies, comments sometimes do. - Ron Jeffries",
            "Perfection is achieved not when there is nothing more to add, but rather when there is nothing more to take away. - Antoine de Saint-Exupery",
            "If debugging is the process of removing software bugs, then programming must be the process of putting them in. - Edsger Dijkstra",
            "Any fool can write code that a computer can understand. Good programmers write code that humans can understand. - Martin Fowler",
            "Programs must be written for people to read, and only incidentally for machines to execute. - Harold Abelson",
            "The best error message is the one that never shows up. - Thomas Fuchs",
            "Simplicity is the ultimate sophistication. - Leonardo da Vinci",
            "Make it work, make it right, make it fast. - Kent Beck",
            "Clean code always looks like it was written by someone who cares. - Robert C. Martin",
            "The only way to go fast is to go well. - Robert C. Martin",
            "Documentation is a love letter that you write to your future self. - Damian Conway",
            "Without further ado, let me be the Virgil to your Dante, and let me guide you safely through the world of rust programming. - Lukaz Hozda",
            "Before me there were no created things, Only eterne, and I eternal last. All hope abandon, ye who enter in! - Dante's Inferno",
            "I am unaware of a book that would make sense out of making sense - Unknown",
            "Don't trust, verify! - Bitcoin",
            "You could not live with your own failure. Where did that bring you? Back to me - Thanos",
          }
          math.randomseed(os.time())
          local quote = quotes[math.random(#quotes)]:gsub("'", "'\\''") -- Escape single quotes for shell
          return { section = "terminal", cmd = "echo '" .. quote .. "'", height = 2, padding = 1 }
        end,
      },
    },
    terminal = { enabled = true },
    scroll = { enabled = false },
    animate = { enabled = false },
    explorer = {
      replace_netrw = true,
    },
    picker = {
      sources = {
        explorer = {
          auto_close = true,
          layout = {
            preview = true,
            reverse = false,
            layout = {
              box = "horizontal",
              backdrop = true,
              width = 0.9,
              height = 0.9,
              border = "none",
              {
                box = "vertical",
                {
                  win = "input",
                  height = 1,
                  border = "rounded",
                  title = "{title} {live} {flags}",
                  title_pos = "center",
                },
                { win = "list", title = " Results ", title_pos = "center", border = "rounded" },
              },
              {
                win = "preview",
                title = "{preview:Preview}",
                width = 0.65,
                border = "rounded",
                title_pos = "center",
              },
            },
          },
          win = {
            list = {
              wo = { relativenumber = true },
            },
          },
        },
      },
      win = {
        input = {
          keys = {
            ["<C-d>"] = { "preview_scroll_down", mode = { "i", "n" } },
            ["<C-u>"] = { "preview_scroll_up", mode = { "i", "n" } },
            ["<c-b>"] = "",
            ["<c-f>"] = "",
          },
        },
      },
    },
  },
  keys = {
    { "<leader>E", false },
    {
      "<leader>e",
      function()
        Snacks.explorer({ cwd = LazyVim.root() })
      end,
      desc = "Open explorer",
    },
    { "<leader>fe", false },
    { "<leader>fE", false },
    -- Snacks picker
    { "<leader><space>", false },
    { "<leader>/", false },
    {
      "<leader>fr",
      function()
        Snacks.picker.recent({ filter = { cwd = true, show_untracked = true } })
      end,
      desc = "Recent (cwd)",
    },
    { "<leader>ff", LazyVim.pick("files", { root = false, show_untracked = true }), desc = "Find Files (Root Dir)" },
    {
      "<leader>fF",
      function()
        Snacks.picker.files({ hidden = true, ignored = true, exclude = exclude_locs, show_empty = true })
      end,
      desc = "Find Files (cwd)",
    },
    {
      "<leader>fR",
      LazyVim.pick("oldfiles"),
      desc = "Recent (All)",
    },
    {
      "<leader>s<cr>",
      function()
        Snacks.picker.resume()
      end,
      desc = "Resume",
    },
    { "<leader>sg", LazyVim.pick("live_grep", { root = false }), desc = "Grep (Root Dir)" },
    {
      "<leader>sG",
      function()
        Snacks.picker.grep({ hidden = true, ignored = true, live = true, regex = true, exclude = exclude_locs })
      end,
      desc = "Grep (cwd)",
    },
    { "<leader>si", false },
    { "<leader>sR", false },
  },
}

return {
  {
    -- INFO: plugin for comments highlight and keybinding for new comments
    "numToStr/Comment.nvim",
    dependencies = { "folke/todo-comments.nvim" },
    config = function()
      local TAGS = {
        "TODO", "FIXME", "HACK", "NOTE", "BUG", "WARN",
        "PERF", "TEST", "DOC", "REFACTOR", "OPTIMIZE",
        "REVIEW", "DEPRECATED", "SECURITY", "CONFIG"
      }

      _G.todo_complete_func = function(findstart, base)
        if findstart == 1 then
          return vim.fn.col('.') - 1
        else
          local matches = {}
          for _, tag in ipairs(TAGS) do
            table.insert(matches, {word = tag, abbr = tag, menu = '[Comment]'})
          end
          return matches
        end
      end

      local function insert_todo_comment()
        local buf = vim.api.nvim_get_current_buf()
        vim.api.nvim_buf_set_option(buf, 'completefunc', 'v:lua.todo_complete_func')
        
        vim.api.nvim_feedkeys(
          vim.api.nvim_replace_termcodes("<C-x><C-u>", true, true, true),
          'n',
          true
        )

        vim.api.nvim_create_autocmd('CompleteDone', {
          buffer = buf,
          once = true,
          callback = function()
            vim.schedule(function()
              local row, col = unpack(vim.api.nvim_win_get_cursor(0))
              local line = vim.api.nvim_buf_get_lines(buf, row-1, row, false)[1] or ""
              
              for _, tag in ipairs(TAGS) do
                if line:match('^%s*'..tag) then
                  if not line:match(tag..':') then
                    local new_line = line:gsub(tag, tag..': ')
                    vim.api.nvim_buf_set_lines(buf, row-1, row, false, {new_line})
                    line = new_line
                  end
                  
                  require('Comment.api').toggle.linewise.current()
                  vim.api.nvim_win_set_cursor(0, {row, #line + 2})
                  break
                end
              end
              
              vim.api.nvim_buf_set_option(buf, 'completefunc', '')
              vim.cmd('startinsert')
            end)
          end
        })
      end

      require('Comment').setup()
      vim.keymap.set('i', '<C-]>', insert_todo_comment, {
        noremap = true,
        silent = true,
        desc = 'Insert TODO comment'
      })
    end
  },
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      signs = true,
      sign_priority = 8,
      keywords = {
        FIX = { icon = " ", color = "fix", alt = { "FIXME", "fixme","BUG","bug", "fixit","FIXIT","issue", "ISSUE","fix" } },
        TODO = { icon = " ", color = "todo" ,alt={"todo"}},
        HACK = { icon = " ", color = "hack" ,alt={"hack"}},
        WARN = { icon = " ", color = "warn", alt = { "WARNING", "warning","warn" } },
        PERF = { icon = "", color = "perf", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" ,"optim","performance","optimize","perf" } },
        NOTE = { icon = "", color = "note", alt = { "INFO" ,"note","info"} },
        TEST = { icon = "", color = "test", alt = { "TESTING", "PASSED", "FAILED","test","passed","failed"} },
        DOC = { icon = " ", color = "doc", alt = { "DOCUMENT", "DOCS", "COMMENT","document","docs","comment","doc","DOC" } },
        REFACTOR = { icon = " ", color = "refactor", alt = { "RESTRUCTURE", "CLEANUP" ,"refactor","restructure","cleanup"} },
        SECURITY = { icon = "󰢝 ", color = "security", alt = { "SECURE", "VULN", "VULNERABILITY","secure","vuln","vulnerability","security" } },
        CONFIG = { icon = " ", color = "config", alt = { "SETUP", "INIT", "CONFIGURE","config","setup","init","configure" } },
        IDEA = { icon = " ", color = "idea", alt = { "SUGGESTION", "THOUGHT", "CONCEPT","idea","suggestion","concept","thought" } },
        REVIEW = { icon = "󰎞", color = "review", alt = { "REVIEWME", "CHECK" ,"reviewme","check","review" } },
        DEPRECATED = { icon = "󰟢", color = "deprecated", alt = { "REMOVE", "LEGACY","deprecated","remove","legacy" } },
        DEBUG = { icon = "", color = "debug", alt = { "TRACE", "LOG","debug","trace","log" } },
        UX = { icon = "󰉋", color = "ux", alt = { "UI", "USABILITY", "USER","user","ui","ux","usability" } },
        DATABASE = { icon = "", color = "database", alt = { "SQL", "DB", "SCHEMA","sql","db","schema","database" } },
      },
      merge_keywords = true,
      highlight = {
        multiline = true,
        multiline_pattern = "^.",
        multiline_context = 10,
        before = "",
        keyword = "wide",
        after = "fg",
        pattern = [[.*<\c(KEYWORDS)\s*:]],
        comments_only = true,
        max_line_len = 400,
        exclude = {},
      },
      search = {
        command = "rg",
        args = {
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--ignore-case",
        },
        pattern = [[\b\c(KEYWORDS):]],
      },
      gui_style = {
        fg = "NONE",
        bg = "BOLD",
      },
      colors = {
        fix = { "#FF5555" }, 
        todo = { "#70E08E" },
        hack = { "#FF8F6B" }, 
        warn = { "#FFE066" },
        perf = { "#D19DFE" },   
        note = { "#6BE5F9" },
        test = { "#FF8FCF" }, 
        doc = { "#5FD7FF" }, 
        refactor = { "#AF91Ff" },
        security = { "#FF7B54" },
        config = { "#6DA9FF" },
        idea = { "#1bbcb3" },
        review = { "#FF9AA9" },
        deprecated = { "#B8B8C0" },
        debug = { "#C774FA" }, 
        ux = { "#FFB3D9" },   
        database = { "#6DDBE5" },
      },
    }
  }
}
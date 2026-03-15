-- INFO: central registry used by all plugins
local TAG_DEFS = {
  TODO       = { icon="", color="todo",       hex="#74E08E" },
  FIX        = { icon="", color="fix",        hex="#FF5555", alt={"FIXME","BUG"} },
  HACK       = { icon="", color="hack",       hex="#FF8F6B" },
  WARN       = { icon="", color="warn",       hex="#FFE066" },
  PERF       = { icon="", color="perf",       hex="#D19DFE", alt={"OPTIMIZE"} },
  NOTE       = { icon="", color="note",       hex="#6BE5F9" },
  INFO       = { icon="", color="info",       hex="#4FC1FF" },
  TEST       = { icon="", color="test",       hex="#A3E635" },
  DOC        = { icon="", color="doc",        hex="#60A5FA" },
  REFACTOR   = { icon="", color="refactor",   hex="#C084FC" },
  SECURITY   = { icon="󰢝", color="security",  hex="#F87171" },
  CONFIG     = { icon="", color="config",     hex="#FACC15" },
  REVIEW     = { icon="󰎞", color="review",     hex="#FB923C" },
  DEPRECATED = { icon="󰟢", color="deprecated", hex="#94A3B8" },
}

-- INFO: generated structures
local TAGS = {}
local ICONS = {}
local TAG_COLOR = {}
local COLORS = {}
local KEYWORDS = {}
local HEX_BY_COLOR = {}

for tag,data in pairs(TAG_DEFS) do
  table.insert(TAGS,tag)

  ICONS[tag] = data.icon
  TAG_COLOR[tag] = data.color
  COLORS[data.color] = { data.hex }
  HEX_BY_COLOR[data.color] = data.hex

  KEYWORDS[tag] = {
    icon = data.icon.." ",
    color = data.color,
    alt = data.alt
  }

  if data.alt then
    for _,alt in ipairs(data.alt) do
      table.insert(TAGS,alt)
      ICONS[alt] = data.icon
      TAG_COLOR[alt] = data.color
    end
  end
end


return {

{
  "numToStr/Comment.nvim",

  dependencies = {
    "folke/todo-comments.nvim",
    "nvim-lua/plenary.nvim",
  },

  config = function()

    local icon_hl = {}

    -- INFO: create highlight groups dynamically
    for tag,group in pairs(TAG_COLOR) do
      local hl = "TodoIcon"..tag

      vim.api.nvim_set_hl(0,hl,{
        fg="#1e1e2e",
        bg=HEX_BY_COLOR[group],
        bold=true
      })

      icon_hl[tag] = hl
    end

    -- INFO: completion function
    _G.todo_complete_func = function(findstart, base)

      if findstart == 1 then
        return vim.fn.col('.') - 1
      end

      local matches = {}

      for _,tag in ipairs(TAGS) do
        matches[#matches+1] = {
          word = tag,
          abbr = tag,
          menu = "[Comment]"
        }
      end

      return matches
    end

    local function insert_todo_comment()

      local buf = vim.api.nvim_get_current_buf()

      vim.api.nvim_buf_set_option(buf,"completefunc","v:lua.todo_complete_func")

      vim.api.nvim_feedkeys(
        vim.api.nvim_replace_termcodes("<C-x><C-u>",true,true,true),
        "n",
        true
      )

      vim.api.nvim_create_autocmd("CompleteDone",{
        buffer = buf,
        once = true,

        callback = function()

          vim.schedule(function()

            local row,col = unpack(vim.api.nvim_win_get_cursor(0))
            local line = vim.api.nvim_buf_get_lines(buf,row-1,row,false)[1] or ""

            for _,tag in ipairs(TAGS) do
              if line:match("^%s*"..tag) then

                if not line:match(tag..":") then
                  line = line:gsub(tag,tag..": ")
                  vim.api.nvim_buf_set_lines(buf,row-1,row,false,{line})
                end

                require("Comment.api").toggle.linewise.current()

                vim.api.nvim_win_set_cursor(0,{row,#line+2})
                break
              end
            end

            vim.api.nvim_buf_set_option(buf,"completefunc","")
            vim.cmd("startinsert")

          end)

        end
      })

    end

    require("Comment").setup()

    vim.keymap.set("i","<C-]>",insert_todo_comment,{
      noremap=true,
      silent=true,
      desc="Insert TODO comment"
    })

    -- INFO: namespace for virtual icons
    local ns = vim.api.nvim_create_namespace("todo_virtual_icons")

    local function render_icons(buf)

      vim.api.nvim_buf_clear_namespace(buf,ns,0,-1)

      local lines = vim.api.nvim_buf_get_lines(buf,0,-1,false)

      for i,line in ipairs(lines) do
        for tag,icon in pairs(ICONS) do

          local col = line:find(tag..":")

          if col then

            vim.api.nvim_buf_set_extmark(buf,ns,i-1,col-1,{
              virt_text = {
                { " "..icon.." ", icon_hl[tag] or "Todo" }
              },
              virt_text_pos = "inline",
              hl_mode = "combine",
            })

            break
          end
        end
      end
    end

    vim.api.nvim_create_autocmd(
      {"BufEnter","TextChanged","TextChangedI"},
      {
        callback = function(args)
          render_icons(args.buf)
        end
      }
    )

  end
},

{
  "folke/todo-comments.nvim",

  dependencies = {
    "nvim-lua/plenary.nvim"
  },

  opts = {
    signs = true,
    sign_priority = 8,
    keywords = KEYWORDS,
    colors = COLORS
  }

}

}

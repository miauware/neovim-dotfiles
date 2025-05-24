return {
    -- INFO: Git symbols plugin
    'lewis6991/gitsigns.nvim',
    config = function()
        vim.api.nvim_set_hl(0, 'GitSignsCurrentLineBlame', { fg = '#1efa64', italic = true })

        local function blame_formatter(name, blame_info)
            local git_user = vim.fn.system('git config user.name'):gsub('%s+$', '')
            if name == "You" then
                name = git_user
            end
            return string.format(" %s - %s", name, blame_info.abbrev_sha)
        end

        require('gitsigns').setup({
            signs = {
                add = { text = '+' },
                change = { text = '~' },
                delete = { text = '_' },
                topdelete = { text = '‾' },
                changedelete = { text = '~' },
            },
            current_line_blame = true,
            current_line_blame_opts = {
                virt_text = true,
                virt_text_pos = 'eol',
                delay = 1000,
            },
            current_line_blame_formatter = function(name, blame_info)
                local git_user = vim.fn.system('git config user.name'):gsub('%s+$', '')
                if name == "You" then
                    name = git_user
                end
                return { { string.format("👤 %s - %s", name, blame_info.abbrev_sha), 'GitSignsCurrentLineBlame' } }
            end,
            on_attach = function(bufnr)
                vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>gp', '<cmd>lua require("gitsigns").prev_hunk()<CR>', { noremap = true, silent = true })
                vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>gn', '<cmd>lua require("gitsigns").next_hunk()<CR>', { noremap = true, silent = true })
            end,
        })
    end
}

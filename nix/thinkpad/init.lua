vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.python3_host_prog = "/run/current-system/sw/bin/python3"

vim.g.have_nerd_font = true


vim.cmd.colorscheme "industry"

vim.opt.number = true

vim.opt.relativenumber = true

vim.opt.mouse = 'a'

vim.opt.showmode = false

vim.opt.expandtab = true

local nvim_lsp = vim.lsp
nvim_lsp.config("nixd", {
        settings = {
                nixd = {
                        nixpkgs = {
                                expr = "import <nixpkgs> { }",
                        },
                        formatting = {
                                command = { "nixfmt" },
                        },
                        options = {
                                nixos = {
                                        expr =
                                        '(builtins.getFlake (toString ./.)).nixosConfigurations.<hostname>.options',
                                },
                        },
                },
        },
})

vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('my.lsp', {}),
        callback = function(ev)
                local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))
                if client:supports_method('textDocument/implementation') then
                        -- Create a keymap for vim.lsp.buf.implementation ...
                end

                -- Enable auto-completion. Note: Use CTRL-Y to select an item. |complete_CTRL-Y|
                if client:supports_method('textDocument/completion') then
                        -- Optional: trigger autocompletion on EVERY keypress. May be slow!
                        -- local chars = {}; for i = 32, 126 do table.insert(chars, string.char(i)) end
                        -- client.server_capabilities.completionProvider.triggerCharacters = chars

                        vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
                end

                -- Auto-format ("lint") on save.
                -- Usually not needed if server supports "textDocument/willSaveWaitUntil".
                if not client:supports_method('textDocument/willSaveWaitUntil')
                    and client:supports_method('textDocument/formatting') then
                        vim.api.nvim_create_autocmd('BufWritePre', {
                                group = vim.api.nvim_create_augroup('my.lsp', { clear = false }),
                                buffer = ev.buf,
                                callback = function()
                                        vim.lsp.buf.format({ bufnr = ev.buf, id = client.id, timeout_ms = 1000 })
                                end,
                        })
                end
        end,
})

vim.lsp.enable('tinymist')
vim.lsp.enable('nixd')
vim.lsp.enable('lua_ls')

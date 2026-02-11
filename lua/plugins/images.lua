return {
  {
    -- Virtual plugin for image/PDF keymaps
    -- Snacks sets filetype to "image" for all image/PDF buffers.
    dir = vim.fn.stdpath "config",
    name = "image-keymaps",
    ft = "image",
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "image",
        callback = function(args)
          vim.keymap.set("n", "<leader>io", function()
            local name = vim.api.nvim_buf_get_name(0)
            local filepath = vim.split(name, "#page=", { plain = true })[1]
            if filepath == "" then
              return
            end
            local argv
            if vim.fn.has "mac" == 1 then
              argv = { "open", filepath }
            elseif vim.fn.has "unix" == 1 then
              argv = { "xdg-open", filepath }
            elseif vim.fn.has "win32" == 1 then
              argv = { "cmd", "/c", "start", "", filepath }
            end

            if argv then
              vim.system(argv, { detach = true })
              vim.notify("Opened " .. vim.fn.fnamemodify(filepath, ":t") .. " in external viewer", vim.log.levels.INFO)
            else
              vim.notify("Could not determine command to open file", vim.log.levels.ERROR)
            end
          end, { buffer = args.buf, desc = "Image: Open in external viewer" })
        end,
        group = vim.api.nvim_create_augroup("ImageExternalOpener", { clear = true }),
      })
    end,
  },
}

return {
  {
    -- Virtual plugin for image/PDF lifecycle guards and keymaps.
    -- Snacks sets filetype to "image" for all image/PDF buffers.
    dir = vim.fn.stdpath "config",
    name = "image-keymaps",
    init = function()
      local security = require "core.security"
      local IMAGE_EXTS = {
        "*.png",
        "*.jpg",
        "*.jpeg",
        "*.gif",
        "*.bmp",
        "*.webp",
        "*.tiff",
        "*.heic",
        "*.avif",
        "*.pdf",
      }
      local MAX_IMAGE_SIZE = 100 * 1024 * 1024 -- 100 MB

      -- Guard 1: prevent snacks.quickfile from intercepting image files before BufReadCmd fires,
      -- which would display raw binary escape codes instead of rendered images.
      vim.api.nvim_create_autocmd("BufReadPre", {
        pattern = IMAGE_EXTS,
        group = vim.api.nvim_create_augroup("ImageQuickfileGuard", { clear = true }),
        callback = function()
          vim.b.snacks_quickfile = false
        end,
      })

      -- Guard 2: warn before imagemagick conversion of large files to prevent OOM / hangs.
      vim.api.nvim_create_autocmd("BufReadPre", {
        pattern = IMAGE_EXTS,
        group = vim.api.nvim_create_augroup("ImageSizeGuard", { clear = true }),
        callback = function(args)
          local stat = vim.uv.fs_stat(args.file)
          if stat and stat.size > MAX_IMAGE_SIZE then
            vim.notify(
              string.format(
                "Large image: %.0f MB — rendering may be slow or memory-intensive.",
                stat.size / (1024 * 1024)
              ),
              vim.log.levels.WARN
            )
          end
        end,
      })

      -- Keymap: open image/PDF in system viewer.
      -- Capture args.buf in closure; do not rely on buf 0 at keymap execution time.
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "image",
        group = vim.api.nvim_create_augroup("ImageExternalOpener", { clear = true }),
        callback = function(args)
          local buf = args.buf
          vim.keymap.set("n", "<leader>io", function()
            local name = vim.api.nvim_buf_get_name(buf)
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
              if security.confirm_external("Open file in external viewer?", filepath) then
                vim.system(argv, { detach = true })
                vim.notify(
                  "Opened " .. vim.fn.fnamemodify(filepath, ":t") .. " in external viewer",
                  vim.log.levels.INFO
                )
              end
            else
              vim.notify("Could not determine command to open file", vim.log.levels.ERROR)
            end
          end, { buffer = buf, desc = "Image: Open in external viewer" })
        end,
      })
    end,
  },
}

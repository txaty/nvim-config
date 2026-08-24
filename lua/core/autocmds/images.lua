-- Image / PDF buffer lifecycle guards and keymaps.
--
-- Snacks.image renders these buffers (it sets filetype "image" for all of
-- them); this module only owns the surrounding editor behaviour.
--
-- Why this lives in core/autocmds/ rather than lua/plugins/: it registers
-- plain autocmds and owns no plugin. It previously masqueraded as a lazy spec
-- with `dir = stdpath("config")` — the same dir the theme picker spec used, so
-- lazy.nvim resolved both fragments to a *single* plugin and the pair only
-- worked by accident. Real autocmds belong here.
local autocmd = vim.api.nvim_create_autocmd
local augroup = function(name)
  return vim.api.nvim_create_augroup(name, { clear = true })
end

local M = {}

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

---Build the platform-appropriate argv for opening a path in the system viewer.
---@param filepath string
---@return string[]|nil
local function external_open_argv(filepath)
  if vim.fn.has "mac" == 1 then
    return { "open", filepath }
  elseif vim.fn.has "win32" == 1 then
    return { "cmd", "/c", "start", "", filepath }
  elseif vim.fn.has "unix" == 1 then
    return { "xdg-open", filepath }
  end
  return nil
end

function M.setup()
  -- Guard 1: prevent snacks.quickfile from intercepting image files before
  -- BufReadCmd fires, which would display raw binary escape codes instead of
  -- rendered images.
  autocmd("BufReadPre", {
    group = augroup "ImageQuickfileGuard",
    pattern = IMAGE_EXTS,
    callback = function()
      vim.b.snacks_quickfile = false
    end,
  })

  -- Guard 2: warn before imagemagick conversion of large files. Conversion can
  -- use 8-10x the file size in memory, so a multi-hundred-MB source can hang or
  -- OOM the converter.
  autocmd("BufReadPre", {
    group = augroup "ImageSizeGuard",
    pattern = IMAGE_EXTS,
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

  -- Keymap: open image/PDF in the system viewer.
  -- args.buf is captured in the closure; buffer 0 at keymap-execution time is
  -- not necessarily the buffer the mapping was created for.
  autocmd("FileType", {
    group = augroup "ImageExternalOpener",
    pattern = "image",
    callback = function(args)
      local buf = args.buf
      vim.keymap.set("n", "<leader>io", function()
        local name = vim.api.nvim_buf_get_name(buf)
        -- Snacks appends "#page=N" for multi-page PDFs; strip it.
        local filepath = vim.split(name, "#page=", { plain = true })[1]
        if filepath == "" then
          return
        end

        local argv = external_open_argv(filepath)
        if not argv then
          vim.notify("Could not determine command to open file", vim.log.levels.ERROR)
          return
        end

        local security = require "core.security"
        if security.confirm_external("Open file in external viewer?", filepath) then
          vim.system(argv, { detach = true })
          vim.notify("Opened " .. vim.fn.fnamemodify(filepath, ":t") .. " in external viewer", vim.log.levels.INFO)
        end
      end, { buffer = buf, desc = "Image: open in external viewer" })
    end,
  })
end

return M

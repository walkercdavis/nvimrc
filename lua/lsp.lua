-- Define signs for signcolumn
vim.fn.sign_define("LspDiagnosticsSignError",
    {text = "", texthl = "LspDiagnosticsDefaultError"})
vim.fn.sign_define("LspDiagnosticsSignWarning",
    {text = "", texthl = "LspDiagnosticsDefaultWarning"})
vim.fn.sign_define("LspDiagnosticsSignInformation",
    {text = "", texthl = "LspDiagnosticsDefaultInformation"})
vim.fn.sign_define("LspDiagnosticsSignHint",
    {text = "", texthl = "LspDiagnosticsSignHint"})

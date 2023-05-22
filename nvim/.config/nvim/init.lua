require("flabber.config")
-- FIX: nvim-cmp and omnifunc seem to compete since nvim-cmp is not require-setuped within the lsp-zero config. Sometimes
-- nvim-cmp works fine. Sometimes <tab> crashes, sometimes when <C-p> or <C-n> cmp window gets replaced by omnifunc

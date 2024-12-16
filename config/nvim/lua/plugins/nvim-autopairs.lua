return {
    'windwp/nvim-autopairs',
    opts = {
        check_ts = true, -- use treesitter
        ts_config = {
            java = false, -- apparently you should disable this for java
        },
        fast_wrap = {}, -- press <M-e> to close a pair
    },
}

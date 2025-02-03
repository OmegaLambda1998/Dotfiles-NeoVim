local opts, spec = OL.spec:add("folke/persistence.nvim")
spec.event = {
    "BufReadPre",
}

-- opts.branch = true
opts.need = math.huge

OL.opt("sessionoptions", "buffers,curdir,folds,help,skiprtp,tabpages")

local function delete_session()
    OL.load(
        "persistence", {}, function(session)
            local sfile = session.current()
            if sfile and vim.uv.fs_stat(sfile) ~= 0 then
                session.stop()
                vim.fn.system("rm " .. vim.fn.fnameescape(sfile))
            end
        end
    )
end

spec.keys = {
    {
        "<leader>sw",
        function()
            OL.load(
                "persistence", {}, function(session)
                    session.start()
                end

            )
        end,
        desc = "Session Save",
    },
    {
        "<leader>ss",
        function()
            OL.load(
                "persistence", {}, function(session)
                    session.load()
                end

            )
        end,
        desc = "Session Load",
    },
    {
        "<leader>sd",
        function()
            delete_session()
        end,
        desc = "Delete Session",
    },
    {
        "<leader>sS",
        function()
            OL.load(
                "persistence", {}, function(session)
                    session.load(
                        {
                            last = true,
                        }
                    )
                end

            )
        end,
        desc = "Session Load Prev",
    },
    {
        "<leader>sg",
        function()
            OL.load(
                "persistence", {}, function(session)
                    session.select()
                end

            )
        end,
        desc = "Session Select",
    },
    {
        "<leader>gs",
        function()
            OL.load(
                "persistence", {}, function(session)
                    session.select()
                end

            )
        end,
        desc = "Session Select",
    },

}

OL.map(
    {
        "<leader>s",
        group = "Sessions",
        desc = "Sessions",
        { spec.keys },
    }
)

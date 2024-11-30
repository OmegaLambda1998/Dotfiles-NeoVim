local opts, spec = OL.spec:add("folke/persistence.nvim")
spec.event = {
    "BufReadPre",
}

-- opts.branch = true
opts.need = math.huge

OL.opt("sessionoptions", "buffers,curdir,folds,help,skiprtp,tabpages")

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

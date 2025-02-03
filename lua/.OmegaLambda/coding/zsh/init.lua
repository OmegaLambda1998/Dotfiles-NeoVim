vim.filetype.add(
    {
        extension = {
            zsh = "sh",
            sh = "sh",
        },
        filename = {
            [".zshrc"] = "sh",
            [".zshenv"] = "sh",
        },
        pattern = {
            ["%.zsh.*"] = "sh",
        },
    }
)

OL.paths.editor = "editor"

OL.loadall(
  "*", {
      from = OL.paths.editor,
      exclude = {
          "init",
      },
  }
)

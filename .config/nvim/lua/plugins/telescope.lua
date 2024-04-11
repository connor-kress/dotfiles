return {
  "nvim-telescope/telescope.nvim",
  tag = "0.1.6",
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {
    defaults = {
      file_ignore_patterns = {
        "node%_modules/.*",
        "package%-lock.json",
        "lazy%-lock.json",
        "CMakeFiles",
        "build",
        ".git/.*",
        "%.o",
        "%.out",
      },
    },
  },
}

return
{
    "christoomey/vim-tmux-navigator",
    lazy = false,
    cmd =
    {
        "TmuxNavigateLeft",
        "TmuxNavigateDown",
        "TmuxNavigateUp",
        "TmuxNavigateRight",
    },
    keys = require("../keys").tmux()
}

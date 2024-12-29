return
{
    "christoomey/vim-tmux-navigator",
    lazy = false,

    config = function()
        require("../keys").tmux();
    end,
}

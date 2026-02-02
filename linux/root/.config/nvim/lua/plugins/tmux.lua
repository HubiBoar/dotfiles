return
{
    "christoomey/vim-tmux-navigator",
    commit = "412c474e97468e7934b9c217064025ea7a69e05e",
    lazy = false,

    config = function()
        require("../keys").tmux();
    end,
}

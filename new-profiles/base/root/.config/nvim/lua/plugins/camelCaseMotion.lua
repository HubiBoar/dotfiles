local M = {}

M.pack = {
  src = "https://github.com/bkad/CamelCaseMotion",
  version = "de439d7c06cffd0839a29045a103fe4b44b15cdc",
}

M.setup = function()
    require("../keys").camelCaseMotion();
end

return M

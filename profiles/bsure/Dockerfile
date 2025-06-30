FROM cde/base

ENV GITHUB_CLI_VERSION=2.65.0

# ------- DOTNET -------

WORKDIR /installers

RUN wget https://packages.microsoft.com/config/ubuntu/22.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb && \
    dpkg -i packages-microsoft-prod.deb && \
    rm packages-microsoft-prod.deb && \
    apt update && \
    apt install -y dotnet-sdk-9.0=9.0.203-1 && \
    apt install -y dotnet-sdk-8.0=8.0.404-1 && \
    rm -rf /installers

RUN dotnet --version


# ------- NODE -------

WORKDIR /installer
RUN apt-get update && apt-get install nodejs -y && \ 
    apt-get update && apt-get install npm -y


# ------- AZCLI -------

WORKDIR /installers

RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash && \
    apt-get update && \
    apt-get install azure-cli=2.72.0-1~jammy -y --allow-downgrades && \
    rm -rf /installers

RUN az --version


# ------- BICEP -------

RUN az bicep install --version v0.33.93


# ------- AZURE FUNC -------

RUN wget -q https://packages.microsoft.com/config/ubuntu/22.04/packages-microsoft-prod.deb \
    && dpkg -i packages-microsoft-prod.deb \
    && sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-ubuntu-$(lsb_release -cs 2>/dev/null)-prod $(lsb_release -cs 2>/dev/null) main" > /etc/apt/sources.list.d/dotnetdev.list' \
    && apt-get update \
    && apt-get install azure-functions-core-tools-4


# ------- GITHUB CLI -------

RUN curl -L -o gh.tar.gz https://github.com/cli/cli/releases/download/v${GITHUB_CLI_VERSION}/gh_${GITHUB_CLI_VERSION}_linux_amd64.tar.gz \
    && tar -xzvf gh.tar.gz \
    && ls -a \
    && ls ./gh_${GITHUB_CLI_VERSION}_linux_amd64/bin/gh -a \
    && mv ./gh_${GITHUB_CLI_VERSION}_linux_amd64/bin/gh /usr/local/bin/gh \
    && rm gh.tar.gz \
    && rm -rf gh_${GITHUB_CLI_VERSION}_linux_amd64

RUN gh --version



# ------- NVIM PLUGINS --------

RUN mkdir -p /root/.config/nvim/pack/plugins/start

# ---- PLENARY ----

WORKDIR /root/.config/nvim/pack/plugins/start
RUN git clone --depth 1 https://github.com/nvim-lua/plenary.nvim && \
    cd plenary.nvim && \
    git fetch origin 857c5ac632080dba10aae49dba902ce3abf91b35 && \
    git checkout 857c5ac632080dba10aae49dba902ce3abf91b35

# ---- TELESCOPE -----

WORKDIR /root/.config/nvim/pack/plugins/start
RUN git clone --depth 1 https://github.com/nvim-telescope/telescope.nvim && \
    cd telescope.nvim && \
    git fetch origin 6312868392331c9c0f22725041f1ec2bef57c751 && \
    git checkout 6312868392331c9c0f22725041f1ec2bef57c751


# ---- TELESCOPE UI ----

WORKDIR /root/.config/nvim/pack/plugins/start
RUN git clone --depth 1 https://github.com/nvim-telescope/telescope-ui-select.nvim && \
    cd telescope-ui-select.nvim && \
    git fetch origin 6e51d7da30bd139a6950adf2a47fda6df9fa06d2 && \
    git checkout 6e51d7da30bd139a6950adf2a47fda6df9fa06d2

# ---- HARPOON -----

WORKDIR /root/.config/nvim/pack/plugins/start
RUN git clone --depth 1 https://github.com/ThePrimeagen/harpoon.git && \
    cd harpoon && \
    git fetch origin ed1f853847ffd04b2b61c314865665e1dadf22c7 && \
    git checkout ed1f853847ffd04b2b61c314865665e1dadf22c7

# ---- CamelCaseMotion -----
WORKDIR /root/.config/nvim/pack/plugins/start
RUN git clone --depth 1 https://github.com/bkad/CamelCaseMotion.git && \
    cd CamelCaseMotion && \
    git fetch origin de439d7c06cffd0839a29045a103fe4b44b15cdc && \
    git checkout de439d7c06cffd0839a29045a103fe4b44b15cdc

# ---- auto-session -----
WORKDIR /root/.config/nvim/pack/plugins/start
RUN git clone --depth 1 https://github.com/rmagatti/auto-session.git && \
    cd auto-session && \
    git fetch origin 00334ee24b9a05001ad50221c8daffbeedaa0842 && \
    git checkout 00334ee24b9a05001ad50221c8daffbeedaa0842

# ---- cmp-nvim-lsp -----
WORKDIR /root/.config/nvim/pack/plugins/start
RUN git clone --depth 1 https://github.com/hrsh7th/cmp-nvim-lsp.git && \
    cd cmp-nvim-lsp && \
    git fetch origin a8912b88ce488f411177fc8aed358b04dc246d7b && \
    git checkout a8912b88ce488f411177fc8aed358b04dc246d7b

# ---- cmp_luasnip -----
WORKDIR /root/.config/nvim/pack/plugins/start
RUN git clone --depth 1 https://github.com/saadparwaiz1/cmp_luasnip.git && \
    cd cmp_luasnip && \
    git fetch origin 98d9cb5c2c38532bd9bdb481067b20fea8f32e90 && \
    git checkout 98d9cb5c2c38532bd9bdb481067b20fea8f32e90

# ---- friendly-snippets -----
WORKDIR /root/.config/nvim/pack/plugins/start
RUN git clone --depth 1 https://github.com/rafamadriz/friendly-snippets.git && \
    cd friendly-snippets && \
    git fetch origin 572f5660cf05f8cd8834e096d7b4c921ba18e175 && \
    git checkout 572f5660cf05f8cd8834e096d7b4c921ba18e175

# ---- lsp-overloads.nvim -----
WORKDIR /root/.config/nvim/pack/plugins/start
RUN git clone --depth 1 https://github.com/Issafalcon/lsp-overloads.nvim.git && \
    cd lsp-overloads.nvim && \
    git fetch origin 7d766bfccbff2ab0be8089ea4d1493089f67a408 && \
    git checkout 7d766bfccbff2ab0be8089ea4d1493089f67a408

# ---- LuaSnip -----
WORKDIR /root/.config/nvim/pack/plugins/start
RUN git clone --depth 1 https://github.com/L3MON4D3/LuaSnip.git && \
    cd LuaSnip && \
    git fetch origin 5271933f7cea9f6b1c7de953379469010ed4553a && \
    git checkout 5271933f7cea9f6b1c7de953379469010ed4553a

# ---- mason-lspconfig.nvim -----
WORKDIR /root/.config/nvim/pack/plugins/start
RUN git clone --depth 1 https://github.com/williamboman/mason-lspconfig.nvim.git && \
    cd mason-lspconfig.nvim && \
    git fetch origin 1a31f824b9cd5bc6f342fc29e9a53b60d74af245 && \
    git checkout 1a31f824b9cd5bc6f342fc29e9a53b60d74af245

# ---- mason.nvim -----
WORKDIR /root/.config/nvim/pack/plugins/start
RUN git clone --depth 1 https://github.com/williamboman/mason.nvim.git && \
    cd mason.nvim && \
    git fetch origin fc98833b6da5de5a9c5b1446ac541577059555be && \
    git checkout fc98833b6da5de5a9c5b1446ac541577059555be

# ---- nvim-cmp -----
WORKDIR /root/.config/nvim/pack/plugins/start
RUN git clone --depth 1 https://github.com/hrsh7th/nvim-cmp.git && \
    cd nvim-cmp && \
    git fetch origin b5311ab3ed9c846b585c0c15b7559be131ec4be9 && \
    git checkout b5311ab3ed9c846b585c0c15b7559be131ec4be9

# ---- nvim-lspconfig -----
WORKDIR /root/.config/nvim/pack/plugins/start
RUN git clone --depth 1 https://github.com/neovim/nvim-lspconfig.git && \
    cd nvim-lspconfig && \
    git fetch origin a182334ba933e58240c2c45e6ae2d9c7ae313e00 && \
    git checkout a182334ba933e58240c2c45e6ae2d9c7ae313e00

# ---- nvim-treesitter -----
WORKDIR /root/.config/nvim/pack/plugins/start
RUN git clone --depth 1 https://github.com/nvim-treesitter/nvim-treesitter.git && \
    cd nvim-treesitter && \
    git fetch origin 42fc28ba918343ebfd5565147a42a26580579482 && \
    git checkout 42fc28ba918343ebfd5565147a42a26580579482

# ---- nvim-treesitter-textobjects -----
WORKDIR /root/.config/nvim/pack/plugins/start
RUN git clone --depth 1 https://github.com/nvim-treesitter/nvim-treesitter-textobjects.git && \
    cd nvim-treesitter-textobjects && \
    git fetch origin 0f051e9813a36481f48ca1f833897210dbcfffde && \
    git checkout 0f051e9813a36481f48ca1f833897210dbcfffde

# ---- nvim-web-devicons -----
WORKDIR /root/.config/nvim/pack/plugins/start
RUN git clone --depth 1 https://github.com/nvim-tree/nvim-web-devicons.git && \
    cd nvim-web-devicons && \
    git fetch origin 1fb58cca9aebbc4fd32b086cb413548ce132c127 && \
    git checkout 1fb58cca9aebbc4fd32b086cb413548ce132c127

# ---- oil.nvim -----
WORKDIR /root/.config/nvim/pack/plugins/start
RUN git clone --depth 1 https://github.com/stevearc/oil.nvim.git && \
    cd oil.nvim && \
    git fetch origin 08c2bce8b00fd780fb7999dbffdf7cd174e896fb && \
    git checkout 08c2bce8b00fd780fb7999dbffdf7cd174e896fb

# ---- tokyonight.nvim -----
WORKDIR /root/.config/nvim/pack/plugins/start
RUN git clone --depth 1 https://github.com/folke/tokyonight.nvim.git && \
    cd tokyonight.nvim && \
    git fetch origin 057ef5d260c1931f1dffd0f052c685dcd14100a3 && \
    git checkout 057ef5d260c1931f1dffd0f052c685dcd14100a3

# ---- vim-tmux-navigator -----
WORKDIR /root/.config/nvim/pack/plugins/start
RUN git clone --depth 1 https://github.com/christoomey/vim-tmux-navigator.git && \
    cd vim-tmux-navigator && \
    git fetch origin 412c474e97468e7934b9c217064025ea7a69e05e && \
    git checkout 412c474e97468e7934b9c217064025ea7a69e05e

# https://github.com/bkad/CamelCaseMotion.git de439d7c06cffd0839a29045a103fe4b44b15cdc
# https://github.com/rmagatti/auto-session.git 00334ee24b9a05001ad50221c8daffbeedaa0842
# https://github.com/hrsh7th/cmp-nvim-lsp.git a8912b88ce488f411177fc8aed358b04dc246d7b
# https://github.com/saadparwaiz1/cmp_luasnip.git 98d9cb5c2c38532bd9bdb481067b20fea8f32e90
# https://github.com/rafamadriz/friendly-snippets.git 572f5660cf05f8cd8834e096d7b4c921ba18e175
# https://github.com/Issafalcon/lsp-overloads.nvim.git 7d766bfccbff2ab0be8089ea4d1493089f67a408
# https://github.com/L3MON4D3/LuaSnip.git 5271933f7cea9f6b1c7de953379469010ed4553a
# https://github.com/williamboman/mason-lspconfig.nvim.git 1a31f824b9cd5bc6f342fc29e9a53b60d74af245
# https://github.com/jay-babu/mason-nvim-dap.nvim.git 4c2cdc69d69fe00c15ae8648f7e954d99e5de3ea
# https://github.com/williamboman/mason.nvim.git fc98833b6da5de5a9c5b1446ac541577059555be
# https://github.com/hrsh7th/nvim-cmp.git b5311ab3ed9c846b585c0c15b7559be131ec4be9
# https://github.com/neovim/nvim-lspconfig.git a182334ba933e58240c2c45e6ae2d9c7ae313e00
# https://github.com/nvim-treesitter/nvim-treesitter.git 42fc28ba918343ebfd5565147a42a26580579482
# https://github.com/nvim-treesitter/nvim-treesitter-textobjects.git 0f051e9813a36481f48ca1f833897210dbcfffde
# https://github.com/nvim-tree/nvim-web-devicons.git 1fb58cca9aebbc4fd32b086cb413548ce132c127
# https://github.com/stevearc/oil.nvim.git 08c2bce8b00fd780fb7999dbffdf7cd174e896fb
# https://github.com/folke/tokyonight.nvim.git 057ef5d260c1931f1dffd0f052c685dcd14100a3
# https://github.com/christoomey/vim-tmux-navigator.git 412c474e97468e7934b9c217064025ea7a69e05e









# ------- RUN -------

COPY root/ /root/

RUN nvim --headless "+Lazy! sync" +qall
RUN nvim --headless "+MasonInstall --force --all" +qall
RUN nvim --headless "+MasonInstall --force omnisharp" +qall

COPY scripts/ /scripts/

RUN git config --global url."git@github-bsureas:bsureas/".insteadOf "git@github.com:bsureas/"

RUN chmod +x /scripts/entrypoint.sh

ENTRYPOINT ["/scripts/entrypoint.sh"]

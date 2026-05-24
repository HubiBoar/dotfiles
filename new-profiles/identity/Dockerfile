FROM archlinux:base-devel

ARG DEV_USER
ARG DEV_UID
ARG DEV_GID

RUN pacman -Syu --noconfirm \
      #sudo \
      git \
      openssh \
      ca-certificates \
      curl \
      wget \
      zsh \
      bash-completion \
      less \
      vim \
      nano \
      jq \
      unzip \
      which \
      inetutils \
  && pacman -Scc --noconfirm

RUN pacman -Syu --noconfirm \
      github-cli \
      azure-cli \
  && pacman -Scc --noconfirm

RUN groupadd --gid "${DEV_GID}" "${DEV_USER}" \
  && useradd --uid "${DEV_UID}" --gid "${DEV_GID}" --create-home --shell /bin/zsh "${DEV_USER}" 
 # && echo "${DEV_USER} ALL=(ALL) NOPASSWD:ALL" > "/etc/sudoers.d/${DEV_USER}" \
 # && chmod 0440 "/etc/sudoers.d/${DEV_USER}"

USER ${DEV_USER}

SHELL ["/bin/zsh", "-c"]

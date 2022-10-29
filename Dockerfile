FROM alpine
# RUN apt-get update && apt-get install -y \
#     openssl \
#     net-tools \
#     git \
#     locales \
#     sudo \
#     dumb-init \
#     vim \
#     curl \
#     wget \
#     bash-completion

# RUN chsh -s /bin/bash
# ENV SHELL=/bin/bash
RUN apk add curl sudo wget bash-completion bash tar npm alpine-sdk bash libstdc++ libc6-compat
RUN npm config set python python3
RUN npm install --global code-server --unsafe-perm


# RUN ARCH=amd64 && \
#     curl -sSL "https://github.com/boxboat/fixuid/releases/download/v0.5.1/fixuid-0.5.1-linux-$ARCH.tar.gz" | tar -C /usr/local/bin -xzf - && \
#     chown root:root /usr/local/bin/fixuid && \
#     chmod 4755 /usr/local/bin/fixuid && \
#     mkdir -p /etc/fixuid && \
#     printf "user: coder\ngroup: coder\n" > /etc/fixuid/config.yml

# run ls /opt/code-server
# run /opt/code-server/install.sh
# RUN CODE_SERVER_VERSION=4.8.1 && \
#     mkdir /opt/code-server &&\
#     curl -L https://github.com/cdr/code-server/releases/download/v${CODE_SERVER_VERSION}/code-server-${CODE_SERVER_VERSION}-linux-amd64.tar.gz | tar -xz -C /opt/code-server  --strip-components 1
# ENV PATH="${PATH}:/opt/code-server/bin"

# RUN ls /opt/code-server
    # sudo dpkg -i code-server_${CODE_SERVER_VERSION}_amd64.deb


# ## kubectl
# RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && \
#     chmod +x ./kubectl && \
#     mv ./kubectl /usr/local/bin/kubectl

# ## helm
# RUN HELM_VERSION=v3.7.0 && \
#     mkdir /tmp/helm && \
#     curl -L https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz -o /tmp/helm/helm.tar.gz && \
#     tar xvf /tmp/helm/helm.tar.gz -C /tmp/helm/ && \
#     chmod +x /tmp/helm/linux-amd64/helm && \
#     sudo -S mv /tmp/helm/linux-amd64/helm /usr/local/bin/helm && \
#     rm -r /tmp/helm

# # kubectx/kubens/fzf
# RUN git clone https://github.com/ahmetb/kubectx /opt/kubectx && \
#     ln -s /opt/kubectx/kubectx /usr/local/bin/kubectx && \
#     ln -s /opt/kubectx/kubens /usr/local/bin/kubens && \
#     git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && \
#     ~/.fzf/install

# RUN locale-gen en_US.UTF-8
# # We unfortunately cannot use update-locale because docker will not use the env variables
# # configured in /etc/default/locale so we need to set it manually.
# ENV LC_ALL=en_US.UTF-8

# ## User account
# RUN adduser --disabled-password --gecos '' coder && \
#     adduser coder sudo && \
#     echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers;

# RUN chmod g+rw /home && \
#     mkdir -p /home/coder/workspace && \
#     chown -R coder:coder /home/coder && \
#     chown -R coder:coder /home/coder/workspace;
# USER coder
# RUN git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && \
#         ~/.fzf/install
# RUN echo "source <(kubectl completion bash)" >> /home/coder/.bashrc && \
#     echo "source <(helm completion bash)" >> /home/coder/.bashrc && \
#     echo 'export PS1="\[\e]0;\u@\h: \w\a\]\[\033[01;32m\]\u\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ "' >> /home/coder/.bashrc

# RUN /usr/bin/code-server  --install-extension ms-kubernetes-tools.vscode-kubernetes-tools
# RUN /usr/bin/code-server  --install-extension tumido.crd-snippets
# RUN /usr/bin/code-server  --install-extension ipedrazas.kubernetes-snippets
# RUN /usr/bin/code-server  --install-extension equinusocio.vsc-material-theme-icons
# RUN /usr/bin/code-server  --install-extension Equinusocio.vsc-material-theme
# COPY --chown=coder:coder settings.json /home/coder/.local/share/code-server/User/settings.json
# EXPOSE 8080

# USER root
# COPY script.sh /script.sh
# RUN chmod +x /script.sh

# USER coder
# RUN mkdir /home/coder/project
# WORKDIR /home/coder/project

# CMD ["/script.sh"]
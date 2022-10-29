FROM node:16-alpine as base

ARG HELM_VERSION=v3.7.0
ARG CODE_VERSION=4.8.1

RUN apk add curl sudo wget bash-completion bash tar alpine-sdk libstdc++ libc6-compat python3 dumb-init nodejs gcompat py3-keyring ncurses 
RUN curl -fsSL https://code-server.dev/install.sh | sh -s -- --method standalone --prefix=/usr/local --version=$CODE_VERSION

RUN ARCH=amd64 && \
    curl -sSL "https://github.com/boxboat/fixuid/releases/download/v0.5.1/fixuid-0.5.1-linux-$ARCH.tar.gz" | tar -C /usr/local/bin -xzf - && \
    chown root:root /usr/local/bin/fixuid && \
    chmod 4755 /usr/local/bin/fixuid && \
    mkdir -p /etc/fixuid && \
    printf "user: coder\ngroup: coder\n" > /etc/fixuid/config.yml

RUN curl -L https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl --output /usr/local/bin/kubectl && \
    chmod +x /usr/local/bin/kubectl

RUN mkdir /tmp/helm && \
    curl -L https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz | tar -C /tmp/helm -xz && \
    chmod +x /tmp/helm/linux-amd64/helm && \
    mv /tmp/helm/linux-amd64/helm /usr/local/bin/helm && \
    rm -r /tmp/helm

RUN adduser --disabled-password --gecos '' coder && \
    addgroup sudo && \
    adduser coder sudo && \
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers;

RUN chmod g+rw /home && \
    mkdir -p /home/coder/workspace && \
    chown -R coder:coder /home/coder && \
    chown -R coder:coder /home/coder/workspace;

USER coder


RUN code-server \
    --install-extension ms-kubernetes-tools.vscode-kubernetes-tools \
    --install-extension tumido.crd-snippets \
    --install-extension ipedrazas.kubernetes-snippets \
    --install-extension equinusocio.vsc-material-theme-icons \
    --install-extension Equinusocio.vsc-material-theme 

RUN git clone --depth=1 https://github.com/Bash-it/bash-it.git ~/.bash_it
RUN   ~/.bash_it/install.sh --silent

COPY --chown=coder:coder settings.json /home/coder/.local/share/code-server/Machine/settings.json
COPY --chown=coder:coder .bashrc /home/coder/.bashrc


USER root
COPY script.sh /script.sh
RUN chmod +x /script.sh
RUN apk add tzdata &&\
cp /usr/share/zoneinfo/Europe/Brussels /etc/localtime && \
echo "Europe/Brussels" >  /etc/timezone &&\
apk del tzdata
RUN apk add libuser &&\
mkdir /etc/default &&\
touch /etc/default/useradd /etc/login.defs

USER coder
WORKDIR /home/coder/.bash_it
RUN cp aliases/available/curl.aliases.bash aliases/available/git.aliases.bash aliases/available/kubectl.aliases.bash enabled 
RUN cp completion/available/dirs.completion.bash completion/available/git.completion.bash completion/available/helm.completion.bash completion/available/kubectl.completion.bash completion/available/pip3.completion.bash enabled 
RUN cp plugins/available/dirs.plugin.bash plugins/available/git.plugin.bash plugins/available/history.plugin.bash plugins/available/history-search.plugin.bash plugins/available/python.plugin.bash plugins/available/sudo.plugin.bash enabled

EXPOSE 8080

WORKDIR /home/coder/workspace

CMD ["/script.sh"]
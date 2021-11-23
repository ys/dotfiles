ARG GOLANG_VERSION=1.12.6

# install code-server
FROM ubuntu:19.04 as coder
RUN apt-get update && apt-get install -y curl ca-certificates unzip
RUN curl -sS -L -o coder.tar.gz https://github.com/cdr/code-server/releases/download/1.1156-vsc1.33.1/code-server1.1156-vsc1.33.1-linux-x64.tar.gz && tar xzvf coder.tar.gz code-server1.1156-vsc1.33.1-linux-x64/code-server && mv code-server1.1156-vsc1.33.1-linux-x64/code-server /usr/bin/ && rm coder.tar.gz && rm -rf code-server1.1156-vsc1.33.1-linux-x64

# install 1password
FROM ubuntu:19.04 as onepassword_builder
RUN apt-get update && apt-get install -y curl ca-certificates unzip
RUN curl -sS -o 1password.zip https://cache.agilebits.com/dist/1P/op/pkg/v0.5.5/op_linux_amd64_v0.5.5.zip && unzip 1password.zip op -d /usr/bin &&  rm 1password.zip

# install ngrok
FROM ubuntu:19.04 as ngrok_builder
RUN apt-get update && apt-get install -y curl ca-certificates unzip
RUN curl -sS -o ngrok.zip https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip && unzip ngrok.zip ngrok -d /usr/bin &&  rm ngrok.zip

# base OS
FROM ubuntu:19.04
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update 
RUN apt-get install -y \
    curl ca-certificates \
    gnupg \
	gnupg2 \
	software-properties-common \
	unzip
# Install Krypt.co
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys C4A05888A1C4FA02E1566F859F2A29A569653940
RUN add-apt-repository "deb http://kryptco.github.io/deb kryptco main" # non-Kali Linux only
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -

RUN apt-get update -qq && apt-get upgrade -y && apt-get install -qq -y \
  automake \
  autoconf \
  apt-transport-https \
  build-essential \
  clang \
  cmake \
  dirmngr \
  git \
  htop \
  jq \
  kr \
  libreadline-dev \
  libncurses-dev \
  libpq-dev \
  libssl-dev \
  libyaml-dev \
  libxslt-dev \
  libffi-dev \
  libtool \
  locales \
  man \
  mosh \
  nodejs \
  openssh-server \
  postgresql-contrib \
  ruby-full \
  silversearcher-ag \
  sudo \
  tmate \
  tmux \
  unixodbc-dev \
  webp \
  wget \
  zgen \
  zip \
  zlib1g-dev \
  zsh \
  --no-install-recommends \
  && rm -rf /var/lib/apt/lists/*

# 1Password
COPY --from=onepassword_builder /usr/bin/op /usr/local/bin/

# NGROK
COPY --from=ngrok_builder /usr/bin/ngrok /usr/local/bin/

# CODER
COPY --from=coder /usr/bin/code-server /usr/local/bin/

# Hugo
RUN curl -sS -L -o hugo.deb https://github.com/gohugoio/hugo/releases/download/v0.55.6/hugo_extended_0.55.6_Linux-64bit.deb && apt install ./hugo.deb

RUN mkdir /run/sshd
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
RUN sed 's/#Port 22/Port 3222/' -i /etc/ssh/sshd_config

RUN wget https://dl.google.com/go/go1.12.6.linux-amd64.tar.gz && tar -C /usr/local -xzf go1.12.6.linux-amd64.tar.gz && rm go1.12.6.linux-amd64.tar.gz

RUN locale-gen "en_US.UTF-8"
ENV LANG="en_US.UTF-8"
ENV LC_ALL="en_US.UTF-8"
ENV LANGUAGE="en_US.UTF-8"

# for correct colours is tmux
ENV TERM screen-256color

RUN curl -fLo /usr/local/share/zsh/site-functions/prompt_pure_setup --create-dirs https://raw.githubusercontent.com/sindresorhus/pure/master/pure.zsh
RUN curl -fLo /usr/local/share/zsh/site-functions/async --create-dirs https://raw.githubusercontent.com/sindresorhus/pure/master/async.zsh

# Creating YS and using that user from here

RUN groupadd -g 999 ys && \
    useradd -r -u 999 -g ys -s /usr/bin/zsh -b /home -d /home/ys ys
RUN usermod -aG sudo ys
RUN mkdir /home/ys && \
    chown -R ys:ys /home/ys

RUN echo "ys ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
USER ys

RUN mkdir /home/ys/.ssh && \
    curl -fsL https://github.com/ys.keys > /home/ys/.ssh/authorized_keys && \
    chmod 700 /home/ys/.ssh && \
    chmod 600 /home/ys/.ssh/authorized_keys

# zsh plugins
RUN git clone https://github.com/zsh-users/zsh-syntax-highlighting.git /home/ys/.zsh/zsh-syntax-highlighting
RUN git clone https://github.com/zsh-users/zsh-autosuggestions /home/ys/.zsh/zsh-autosuggestions

# tmux plugins
RUN git clone https://github.com/tmux-plugins/tpm /home/ys/.tmux/plugins/tpm
RUN git clone https://github.com/tmux-plugins/tmux-open.git /home/ys/.tmux/plugins/tmux-open
RUN git clone https://github.com/tmux-plugins/tmux-yank.git /home/ys/.tmux/plugins/tmux-yank
RUN git clone https://github.com/tmux-plugins/tmux-prefix-highlight.git /home/ys/.tmux/plugins/tmux-prefix-highlight

ENV USER ys

USER root

WORKDIR /home/ys

EXPOSE 8443 3222 60000-60010/udp

COPY entrypoint.sh /bin/entrypoint.sh
RUN chmod +x /bin/entrypoint.sh


CMD ["/bin/entrypoint.sh"]

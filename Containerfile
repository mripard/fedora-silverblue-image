ARG FEDORA_MAJOR_VERSION=38

FROM quay.io/fedora-ostree-desktops/silverblue:${FEDORA_MAJOR_VERSION}

RUN wget -O /etc/yum.repos.d/tailscale.repo https://pkgs.tailscale.com/stable/fedora/tailscale.repo
RUN wget -P /etc/udev/rules.d/ https://raw.githubusercontent.com/Nitrokey/libnitrokey/master/data/41-nitrokey.rules

RUN rpm-ostree override remove \
	firefox \
	firefox-langpacks \
	opensc

RUN rpm-ostree -y install \
	b4 \
	emacs \
	isync \
	lei \
	msmtp \
	neomutt \
	picocom \
	python3-pip \
	restic \
	ripgrep \
	strace \
	tailscale \
	vim-enhanced

RUN flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

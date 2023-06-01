ARG FEDORA_MAJOR_VERSION=38

FROM quay.io/fedora-ostree-desktops/silverblue:${FEDORA_MAJOR_VERSION}

ARG FEDORA_MAJOR_VERSION

RUN \
	rpm-ostree install \
		https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-${FEDORA_MAJOR_VERSION}.noarch.rpm \
		https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-${FEDORA_MAJOR_VERSION}.noarch.rpm \
	&& \
	wget -O /etc/yum.repos.d/tailscale.repo https://pkgs.tailscale.com/stable/fedora/tailscale.repo \
	&& \
	wget -P /etc/udev/rules.d/ https://raw.githubusercontent.com/Nitrokey/libnitrokey/master/data/41-nitrokey.rules \
	&& \
	rpm-ostree override remove mesa-va-drivers --install mesa-va-drivers-freeworld \
	&& \
	rpm-ostree override remove \
		firefox \
		firefox-langpacks \
	&& \
	rpm-ostree -y install \
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
		vim-enhanced \
	&& \
	flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo \
	&& \
	rm -rf \
		/tmp/* \
		/var/* \
	&& \
	rpm-ostree cleanup \
	&& \
	ostree container commit

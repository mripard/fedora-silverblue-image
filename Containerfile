ARG FEDORA_MAJOR_VERSION=38

FROM quay.io/fedora-ostree-desktops/silverblue:${FEDORA_MAJOR_VERSION}

ARG FEDORA_MAJOR_VERSION

COPY usr /usr

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
		git-filter-repo \
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
		wl-clipboard \
	&& \
	rpm-ostree -y install fedora-repos-rawhide \
	&& \
	rpm-ostree -y install --enablerepo=rawhide --uninstall gnupg2 gnupg2 \
	&& \
	flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo \
	&& \
	sed -i 's/#AutomaticUpdatePolicy.*/AutomaticUpdatePolicy=stage/' /etc/rpm-ostreed.conf \
	&& \
	systemctl enable rpm-ostreed-automatic.timer \
	&& \
	systemctl enable flatpak-system-update.timer \
	&& \
	rm -rf \
		/tmp/* \
		/var/* \
	&& \
	rpm-ostree cleanup -m \
	&& \
	ostree container commit

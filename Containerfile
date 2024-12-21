ARG FEDORA_MAJOR_VERSION=41

FROM quay.io/fedora-ostree-desktops/silverblue:${FEDORA_MAJOR_VERSION}

ARG FEDORA_MAJOR_VERSION

COPY etc /etc
COPY usr /usr

RUN \
	rpm-ostree install \
		https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-${FEDORA_MAJOR_VERSION}.noarch.rpm \
		https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-${FEDORA_MAJOR_VERSION}.noarch.rpm \
	&& \
	wget -O /etc/yum.repos.d/tailscale.repo https://pkgs.tailscale.com/stable/fedora/tailscale.repo \
	&& \
	wget -O /etc/yum.repos.d/terra.repo https://github.com/terrapkg/subatomic-repos/raw/main/terra.repo \
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
		ansible \
		autoconf \
		automake \
		b4 \
		bison \
		clang-devel \
		cmake \
		coccinelle \
		code \
		containernetworking-plugins \
		cpio \
		did \
		distrobox \
		dfu-util \
		drm-utils \
		dtc \
		dwarves \
		edid-decode \
		elfutils-libelf-devel \
		emacs-nw \
		f${FEDORA_MAJOR_VERSION}-backgrounds \
		fedpkg \
		flex \
		gcc \
		gcc-aarch64-linux-gnu \
		gcc-arm-linux-gnu \
		gcc-c++ \
		gdb \
		gh \
		git \
		git-absorb \
		git-email \
		git-filter-repo \
		glibc-devel \
		glibc-devel.i686 \
		gnome-backgrounds-extras \
		gnome-tweaks \
		htop \
		ibm-plex-fonts-all \
		isync \
		lei \
		lld \
		lldb \
		make \
		meson \
		mold \
		msmtp \
		ncurses-devel \
		neomutt \
		openssl \
		openssl-devel \
		openssl-devel-engine \
		osbuild \
		osbuild-tools \
		patch \
		pdftk \
		perf \
		perl-English \
		perl-FindBin \
		perl-IPC-Cmd \
		perl-open \
		picocom \
		polarsys-b612-fonts-all \
		podman-remote \
		python-cryptography \
		python-devel \
		python-jsonschema \
		python3-pip \
		python-pyelftools \
		python-setuptools \
		python-sphinx \
		python-sphinx_rtd_theme \
		qemu \
		restic \
		ripgrep \
		rpmdevtools \
		strace \
		swig \
		tailscale \
		terra-release \
		uboot-tools \
		v4l-utils \
		vim-enhanced \
		w3m \
		weechat \
		wireshark \
		wl-clipboard \
		zed-preview \
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

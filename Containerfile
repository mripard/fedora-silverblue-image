ARG FEDORA_MAJOR_VERSION=39

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
		autoconf \
		automake \
		b4 \
		bison \
		clang-devel \
		coccinelle \
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
		emacs \
		flex \
		gcc \
		gcc-aarch64-linux-gnu \
		gcc-arm-linux-gnu \
		gcc-c++ \
		gdb \
		git \
		git-absorb \
		git-email \
		git-filter-repo \
		htop \
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
		osbuild \
		osbuild-tools \
		patch \
		perf \
		perl-open \
		picocom \
		podman-remote \
		python-cryptography \
		python-devel \
		python-jsonschema \
		python3-pip \
		python-pyelftools \
		python-setuptools \
		qemu \
		restic \
		ripgrep \
		rpmdevtools \
		strace \
		swig \
		tailscale \
		uboot-tools \
		v4l-utils \
		vim-enhanced \
		w3m \
		wireshark \
		wl-clipboard \
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

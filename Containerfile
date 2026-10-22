ARG FEDORA_MAJOR_VERSION=45

FROM quay.io/fedora-ostree-desktops/silverblue:${FEDORA_MAJOR_VERSION}

ARG FEDORA_MAJOR_VERSION

COPY etc /etc
COPY usr /usr

RUN \
	rpmkeys --import \
		/usr/share/distribution-gpg-keys/rpmfusion/RPM-GPG-KEY-rpmfusion-free-fedora-${FEDORA_MAJOR_VERSION} \
		/usr/share/distribution-gpg-keys/rpmfusion/RPM-GPG-KEY-rpmfusion-nonfree-fedora-${FEDORA_MAJOR_VERSION} \
	&& \
	rpm-ostree -y install \
		https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-${FEDORA_MAJOR_VERSION}.noarch.rpm \
		https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-${FEDORA_MAJOR_VERSION}.noarch.rpm \
	&& \
	wget -P /etc/udev/rules.d/ https://raw.githubusercontent.com/Nitrokey/libnitrokey/master/data/41-nitrokey.rules \
	&& \
	rpm-ostree override remove \
		firefox \
		firefox-langpacks \
	&& \
	rpm-ostree -y install \
		android-tools \
		autoconf \
		automake \
		b4 \
		bat \
		binwalk \
		bison \
		chezmoi \
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
		dt-schema \
		dwarves \
		edid-decode \
		elfutils-devel \
		elfutils-libelf-devel \
		emacs-nw \
		f${FEDORA_MAJOR_VERSION}-backgrounds \
		fd-find \
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
		glab \
		glibc-devel \
		gnome-backgrounds \
		gnome-shell-extension-appindicator \
		gnome-tweaks \
		gnutls-devel \
		go \
		guestfs-tools \
		htop \
		hugo \
		ibm-plex-fonts-all \
		isync \
		lei \
		libvirt-daemon-config-network \
		libvirt-daemon-kvm \
		lld \
		lldb \
		llvm \
		make \
		mesa-va-drivers-freeworld \
		meson \
		mold \
		msmtp \
		ncurses-devel \
		neomutt \
		openssl \
		openssl3-devel \
		openssl3-devel-engine \
		osbuild \
		osbuild-tools \
		patch \
		pdftk \
		perf \
		perl \
		perl-English \
		perl-ExtUtils-MakeMaker \
		perl-FindBin \
		perl-IPC-Cmd \
		perl-open \
		pgp-tools \
		picocom \
		polarsys-b612-fonts-all \
		podman-remote \
		python-cryptography \
		python-jinja2-cli \
		python-jsonschema \
		python-ply \
		python-pyelftools \
		python-pyserial \
		python-sphinx \
		python-sphinx_rtd_theme \
		qemu \
		qemu-kvm \
		repo \
		restic \
		ripgrep \
		rpmdevtools \
		rustup \
		shellcheck \
		strace \
		swig \
		tailscale \
		uboot-tools \
		v4l-utils \
		vim-enhanced \
		w3m \
		wireshark \
		wl-clipboard \
		yamllint \
		yq \
		virt-install \
		virt-manager \
		virt-top \
		virt-viewer \
		virtme-ng \
	&& \
	systemctl enable libvirtd.service \
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

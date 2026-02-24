ARG FEDORA_MAJOR_VERSION=43

FROM quay.io/fedora-ostree-desktops/silverblue:${FEDORA_MAJOR_VERSION}

ARG FEDORA_MAJOR_VERSION

COPY etc /etc
COPY usr /usr

RUN \
	rpm-ostree install \
		https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-${FEDORA_MAJOR_VERSION}.noarch.rpm \
		https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-${FEDORA_MAJOR_VERSION}.noarch.rpm \
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
		android-tools \
		ansible \
		autoconf \
		automake \
		b4 \
		bat \
		binwalk \
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
		glibc-devel \
		glibc-devel.i686 \
		gnome-backgrounds \
		gnome-tweaks \
		gnutls-devel \
		go \
		google-cloud-cli \
		guestfs-tools \
		htop \
		ibm-plex-fonts-all \
		isync \
		lei \
		libvirt-daemon-config-network \
		libvirt-daemon-kvm \
		lld \
		lldb \
		llvm \
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
		python-devel \
		python-jsonschema \
		python3-pip \
		python-pyelftools \
		python-pytest \
		python-setuptools \
		python-sphinx \
		python-sphinx_rtd_theme \
		qemu \
		qemu-kvm \
		restic \
		ripgrep \
		rpmdevtools \
		rust2rpm \
		screen \
		strace \
		swig \
		tailscale \
		uboot-tools \
		v4l-utils \
		vim-enhanced \
		w3m \
		weechat \
		wireshark \
		wl-clipboard \
		yamllint \
		yq \
		virt-install \
		virt-manager \
		virt-top \
		virt-viewer \
		vhs \
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

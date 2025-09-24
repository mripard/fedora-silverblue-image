ARG FEDORA_MAJOR_VERSION=42

FROM quay.io/fedora-ostree-desktops/silverblue:${FEDORA_MAJOR_VERSION}

ARG FEDORA_MAJOR_VERSION

COPY etc /etc
COPY usr /usr
COPY opt /opt

RUN \
	rpm-ostree -y install \
		code \
		distrobox \
		git \
		podman-compose \
		python3-ramalama \
		qemu-system-aarch64 \
		qemu-user-static \
		krb5-workstation \
		vim-enhanced \
		virt-install \
		virt-manager \
		virt-top \
		virt-viewer

# These packages for Automotive Stream Distribution development
RUN \
	rpm-ostree -y install \
		automotive-image-builder \
		jq \
		make \
		osbuild \
		osbuild-auto \
		osbuild-ostree \
		osbuild-selinux \
		osbuild-tools \
		osbuild-luks2 \
		osbuild-lvm2 \
		python3-libselinux \
		rsync

RUN \
	flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

RUN \
	systemctl enable libvirtd.service \
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

ARG FEDORA_MAJOR_VERSION=42

FROM quay.io/fedora-ostree-desktops/silverblue:${FEDORA_MAJOR_VERSION}

ARG FEDORA_MAJOR_VERSION

COPY etc /etc
COPY usr /usr
COPY opt /opt

RUN \
	rpm-ostree -y install \
		distrobox \
		git \
		vim-enhanced \
		virt-install \
		virt-manager \
		virt-top \
		virt-viewer

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

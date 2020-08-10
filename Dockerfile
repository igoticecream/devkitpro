FROM debian:buster-slim

LABEL \
    version="1.0" \
    maintainer="igoticecream@gmail.com" \
    description="Homebrew toolchains for Nintendo by devkitPro" \
    url="https://devkitpro.org/"

ENV DEBIAN_FRONTEND     noninteractive
ENV DEVKITPRO           /opt/devkitpro
ENV DEVKITARM           $DEVKITPRO/devkitARM
ENV DEVKITA64           $DEVKITPRO/devkitA64
ENV DEVKITPPC           $DEVKITPRO/devkitPPC
ENV LIBNX               $DEVKITPRO/libnx
ENV PORTLIBS            $DEVKITPRO/portlibs/switch
ENV SWITCHTOOLS         $DEVKITPRO/tools
ENV PACMAN              $DEVKITPRO/pacman
ENV PATH                $DEVKITARM/bin:$PATH
ENV PATH                $DEVKITA64/bin:$PATH
ENV PATH                $DEVKITPPC/bin:$PATH
ENV PATH                $PORTLIBS/bin:$PATH
ENV PATH                $SWITCHTOOLS/bin:$PATH
ENV PATH                $PACMAN/bin:$PATH

COPY action.sh /usr/bin/action.sh

RUN apt-get update && \
    apt-get install -y --no-install-recommends apt-utils sudo ca-certificates pkg-config build-essential curl wget bzip2 xz-utils make git bsdtar doxygen gnupg && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    chmod +x /usr/bin/action.sh

RUN wget https://github.com/devkitPro/pacman/releases/latest/download/devkitpro-pacman.amd64.deb && \
    dpkg -i devkitpro-pacman.amd64.deb && \
    rm devkitpro-pacman.amd64.deb && \
    dkp-pacman --noconfirm -Scc

RUN dkp-pacman --noconfirm -Syyu switch-dev && \
    dkp-pacman --noconfirm -Syyu 3ds-dev nds-dev gp32-dev gba-dev nds-portlibs && \
    dkp-pacman --noconfirm -Syyu gamecube-dev wii-dev wiiu-dev && \
    dkp-pacman --noconfirm -S --needed `dkp-pacman -Slq dkp-libs | grep '^switch-'` && \
    dkp-pacman --noconfirm -S --needed `dkp-pacman -Slq dkp-libs | grep '^3ds-'` && \
    dkp-pacman --noconfirm -S --needed `dkp-pacman -Slq dkp-libs | grep '^ppc-'` && \
    dkp-pacman --noconfirm -S --needed devkitARM && \
    dkp-pacman --noconfirm -S --needed devkitarm-rules && \
    dkp-pacman --noconfirm -S --needed devkitpro-pkgbuild-helpers && \
    dkp-pacman --noconfirm -Scc

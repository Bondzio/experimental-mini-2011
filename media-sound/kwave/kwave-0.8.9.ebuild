# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/kwave/kwave-0.8.9.ebuild,v 1.3 2013/06/11 15:53:00 ago Exp $

EAPI=5

KDE_LINGUAS="cs de fr"
KDE_HANDBOOK="optional"
inherit kde4-base

DESCRIPTION="A sound editor for KDE that can edit many types of audio files"
HOMEPAGE="http://kwave.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}-1.tar.bz2"

LICENSE="BSD GPL-2 LGPL-2
	handbook? ( FDL-1.2 )"
SLOT="4"
KEYWORDS="amd64 x86"
IUSE="alsa debug flac handbook mp3 oss phonon pulseaudio vorbis"

RDEPEND="
	media-libs/audiofile
	>=sci-libs/fftw-3
	media-libs/libsamplerate
	alsa? ( media-libs/alsa-lib )
	flac? ( media-libs/flac )
	mp3? (
		media-libs/id3lib
		media-libs/libmad
		|| ( media-sound/lame media-sound/twolame media-sound/toolame )
	)
	phonon? ( media-libs/phonon )
	pulseaudio? ( media-sound/pulseaudio )
	vorbis? (
		media-libs/libogg
		media-libs/libvorbis
	)
"
DEPEND="${RDEPEND}
	$(add_kdebase_dep kdesdk-misc extras)
	|| ( media-gfx/imagemagick[png,svg] media-gfx/graphicsmagick[imagemagick,png,svg] )
"

DOCS=( AUTHORS CHANGES LICENSES README TODO )

src_configure() {
	local mycmakeargs=(
		-DWITH_SAMPLERATE=ON
		$(cmake-utils_use_with alsa)
		$(cmake-utils_use_with flac)
		$(cmake-utils_use_with mp3)
		$(cmake-utils_use_with vorbis OGG)
		$(cmake-utils_use_with oss)
		$(cmake-utils_use_with phonon)
		$(cmake-utils_use_with pulseaudio)
		$(cmake-utils_use debug)
	)

	kde4-base_src_configure
}

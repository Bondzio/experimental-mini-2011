# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/split2flac/split2flac-0.1_pre20110712.ebuild,v 1.2 2011/10/13 18:47:09 maksbotan Exp $

EAPI="4"

DESCRIPTION="sh script to split one big APE/FLAC/WV/WAV audio image with CUE sheet into tracks"
HOMEPAGE="https://code.google.com/p/split2flac/"
SRC_URI="http://dev.gentoo.org/~maksbotan/${PN}-${PV##*_pre}.sh"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="flake imagemagick mac mp3 mp4 ogg replaygain wavpack"

RDEPEND="
	app-cdr/cuetools
	media-sound/shntool[mac?]
	virtual/libiconv
	media-libs/flac
	flake? ( media-sound/flake )
	mp3? ( media-sound/lame || ( media-libs/mutagen media-libs/id3lib ) )
	mp4? ( media-libs/faac media-libs/libmp4v2[utils] )
	ogg? ( media-sound/vorbis-tools )
	wavpack? ( media-sound/wavpack )
	replaygain? (
		mp3? ( media-sound/mp3gain )
		mp4? ( media-sound/aacgain )
		ogg? ( media-sound/vorbisgain )
	)
	imagemagick? ( media-gfx/imagemagick )
"

S="${WORKDIR}"

src_unpack() {
	cp "${DISTDIR}"/${PN}-${PV##*_pre}.sh "${WORKDIR}"/${PN}.sh
}

src_install() {
	dobin "${PN}.sh"
	dosym "${PN}.sh" /usr/bin/split2wav.sh
	for i in mp3 mp4 ogg
	do
		use $i && dosym "${PN}.sh" /usr/bin/split2${i/mp4/m4a}.sh
	done
}
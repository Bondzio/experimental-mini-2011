# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/mp3fs/mp3fs-0.32.ebuild,v 1.3 2012/08/14 11:56:24 johu Exp $

DESCRIPTION="a read-only FUSE filesystem which transcodes FLAC audio files to MP3 when read"
HOMEPAGE="http://khenriks.github.com/mp3fs/"
SRC_URI="https://github.com/downloads/khenriks/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="sys-fs/fuse
	media-libs/libid3tag
	media-libs/flac
	media-sound/lame
	media-libs/libogg"
RDEPEND="${DEPEND}"

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog NEWS README.rst
}

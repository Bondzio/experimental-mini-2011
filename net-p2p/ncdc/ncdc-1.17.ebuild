# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/ncdc/ncdc-1.17.ebuild,v 1.4 2013/06/23 21:32:33 xmw Exp $

EAPI=5

inherit toolchain-funcs

DESCRIPTION="ncurses directconnect client"
HOMEPAGE="http://dev.yorhel.nl/ncdc"
SRC_URI="http://dev.yorhel.nl/download/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE=""

RDEPEND="app-arch/bzip2
	dev-db/sqlite:3
	dev-libs/glib:2
	net-libs/gnutls
	sys-libs/ncurses:5[unicode]
	sys-libs/zlib"
DEPEND="${RDEPEND}
	dev-lang/perl
	dev-util/makeheaders
	virtual/pkgconfig"

src_compile() {
	emake AR="$(tc-getAR)"
}

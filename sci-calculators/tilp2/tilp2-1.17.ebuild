# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-calculators/tilp2/tilp2-1.17.ebuild,v 1.1 2013/07/09 17:09:57 bicatali Exp $

EAPI=5

inherit autotools-utils

DESCRIPTION="Communication program for Texas Instruments calculators "
HOMEPAGE="http://lpg.ticalc.org/prj_tilp"
SRC_URI="mirror://sourceforge/tilp/tilp2-linux/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE="nls threads xinerama"

RDEPEND="
	dev-libs/glib:2
	gnome-base/libglade:2.0
	x11-libs/gtk+:2
	>=sci-libs/libticalcs2-1.1.8
	>=sci-libs/libticables2-1.3
	>=sci-libs/libtifiles2-1.1.6
	>=sci-libs/libticonv-1.1.4
	nls? ( virtual/libintl )
	xinerama? ( x11-libs/libXinerama )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
	xinerama? ( x11-proto/xineramaproto )"

src_configure() {
	# kde seems to be kde3 only
	local myeconfargs=(
		--disable-rpath
		--without-kde
		$(use_enable nls)
		$(use_enable threads threading)
		$(use_with xinerama)
	)
	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install
	rm "${ED}"usr/share/${PN}/{Manpage.txt,COPYING,RELEASE,AUTHORS,LICENSES} || die
}

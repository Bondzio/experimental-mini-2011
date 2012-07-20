# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
inherit xorg-2 flag-o-matic

DESCRIPTION="X.Org Xft library"

KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris ~x86-winnt"
IUSE="cleartype +lcdfilter"

RDEPEND=">=x11-libs/libXrender-0.8.2
	x11-libs/libX11
	x11-libs/libXext
	media-libs/fontconfig[lcdfilter=,cleartype=]
	media-libs/freetype[lcdfilter=]
	x11-proto/xproto
	virtual/ttf-fonts"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-bold-fonts.patch
)

pkg_setup() {
	if use cleartype && use lcdfilter; then
		eerror "The cleartype and lcdfilter useflags are mutually exclusive,"
		eerror "you must disable one of them."
		die "Either disable the cleartype or the lcdfilter useflag."
	fi
}

src_install() {
	xorg-2_src_install

	insinto /usr/share/X11/app-defaults
	doins "${FILESDIR}"/Xft
}

pkg_postinst() {
	echo
	ewarn "DO NOT report bugs to Gentoo's bugzilla"
	ewarn "See http://forums.gentoo.org/viewtopic-t-511382.html for support topic on Gentoo forums."
	echo
}

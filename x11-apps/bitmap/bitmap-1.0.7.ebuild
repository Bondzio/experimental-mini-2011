# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-apps/bitmap/bitmap-1.0.7.ebuild,v 1.1 2013/05/20 23:44:16 chithanh Exp $

EAPI=5

inherit xorg-2

DESCRIPTION="X.Org bitmap application"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd"
IUSE=""
RDEPEND="x11-libs/libX11
	x11-libs/libXmu
	x11-libs/libXaw
	x11-libs/libXt
	x11-misc/xbitmaps"
DEPEND="${RDEPEND}"

# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kcalc/kcalc-4.10.5.ebuild,v 1.1 2013/07/02 16:47:31 johu Exp $

EAPI=5

KDE_HANDBOOK="optional"
CPPUNIT_REQUIRED="optional"
inherit kde4-base

DESCRIPTION="KDE calculator"
KEYWORDS=" ~amd64 ~arm ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="debug"

DEPEND="
	dev-libs/gmp
"
RDEPEND="${DEPEND}"

src_test() {
	LANG=C kde4-base_src_test
}

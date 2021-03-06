# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-leechcraft/lcpackgen/lcpackgen-1.2.ebuild,v 1.1 2013/07/03 16:52:54 maksbotan Exp $

EAPI="5"

inherit cmake-utils

DESCRIPTION="Package creator for app-leechcraft/lc-lackman package manager"

SRC_URI="https://github.com/0xd34df00d/lcpackgen/archive/${PV}.tar.gz"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

HOMEPAGE="http://leechcraft.org/"
LICENSE="Boost-1.0"

S="${WORKDIR}/lcpackgen-${PV}"
CMAKE_USE_DIR="${S}"/src

COMMON_DEPEND=">=dev-libs/boost-1.46
	dev-qt/qtcore:4
	dev-qt/qtgui:4"
DEPEND="${COMMON_DEPEND}"
RDEPEND="${COMMON_DEPEND}
	dev-qt/qtsvg:4"
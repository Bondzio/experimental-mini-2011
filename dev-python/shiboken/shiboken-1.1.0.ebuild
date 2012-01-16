# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/shiboken/shiboken-1.1.0.ebuild,v 1.1 2012/01/15 11:23:11 hwoarang Exp $

EAPI=3

PYTHON_DEPEND="2:2.5"

inherit python versionator cmake-utils

MY_PV=$(replace_version_separator '_' '~')
MY_P=${PN}-${MY_PV}

DESCRIPTION="A tool for creating Python bindings for C++ libraries"
HOMEPAGE="http://www.pyside.org/"
SRC_URI="http://www.pyside.org/files/${MY_P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug test"

DEPEND=">=dev-python/apiextractor-0.10.10
	>=dev-python/generatorrunner-0.6.16
	>=x11-libs/qt-core-4.7.0"
RDEPEND="${DEPEND}
	!dev-python/boostpythongenerator"

PATCHES=( "${FILESDIR}/${PN}-1.0.9-fix-pkgconfig.patch" )

DOCS=( ChangeLog )

S=${WORKDIR}/${MY_P}

pkg_setup() {
	python_set_active_version 2
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_build test TESTS)
	)
	cmake-utils_src_configure
}
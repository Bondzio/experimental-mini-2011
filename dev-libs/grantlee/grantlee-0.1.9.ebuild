# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/grantlee/grantlee-0.1.9.ebuild,v 1.1 2012/01/12 16:32:56 johu Exp $

EAPI=4

inherit cmake-utils

DESCRIPTION="C++ string template engine based on the Django template system"
HOMEPAGE="http://www.gitorious.org/grantlee/pages/Home"
SRC_URI="http://www.loegria.net/grantlee/${P}.tar.gz"

LICENSE="LGPL-2.1"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86"
SLOT="0"
IUSE="debug doc test"

COMMON_DEPEND="
	>=x11-libs/qt-core-4.5.0:4
	>=x11-libs/qt-gui-4.5.0:4
	>=x11-libs/qt-script-4.5.0:4
"
DEPEND="${COMMON_DEPEND}
	doc? ( app-doc/doxygen[-nodot] )
"
RDEPEND="${COMMON_DEPEND}"

DOCS=(AUTHORS CHANGELOG GOALS README)

# Some tests fail
RESTRICT="test"

src_configure() {
	mycmakeargs=(
		$(cmake-utils_use_build test TESTS)
	)

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile

	use doc && cmake-utils_src_compile docs
}

src_install() {
	use doc && HTML_DOCS=("${CMAKE_BUILD_DIR}/apidox/")

	cmake-utils_src_install
}
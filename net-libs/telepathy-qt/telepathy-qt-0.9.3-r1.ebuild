# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/telepathy-qt/telepathy-qt-0.9.3-r1.ebuild,v 1.1 2013/06/05 21:35:40 johu Exp $

EAPI=5

PYTHON_COMPAT=( python{2_5,2_6,2_7} )
inherit base python-any-r1 cmake-utils virtualx

DESCRIPTION="Qt4 bindings for the Telepathy D-Bus protocol"
HOMEPAGE="http://telepathy.freedesktop.org/"
SRC_URI="http://telepathy.freedesktop.org/releases/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="debug farsight farstream test"

RDEPEND="
	dev-qt/qtcore:4
	dev-qt/qtdbus:4
	farsight? (
		net-libs/telepathy-farsight
	)
	farstream? (
		>=net-libs/telepathy-farstream-0.2.2
		>=net-libs/telepathy-glib-0.18.0
	)
	!net-libs/telepathy-qt4
"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	virtual/pkgconfig
	test? (
		dev-libs/dbus-glib
		dev-libs/glib
		dev-python/dbus-python
		dev-qt/qttest:4
	)
"

REQUIRED_USE="farsight? ( !farstream )"

DOCS=( AUTHORS ChangeLog HACKING NEWS README )

PATCHES=(
	"${FILESDIR}/${P}-tp-glib-0.18-tests.patch"
	"${FILESDIR}/${P}-avatar-duplication.patch"
)

pkg_setup() {
	python-any-r1_pkg_setup
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_enable farsight)
		$(cmake-utils_use_enable farstream)
		$(cmake-utils_use_enable debug DEBUG_OUTPUT)
		$(cmake-utils_use_enable test TESTS)
		-DENABLE_EXAMPLES=OFF
	)
	cmake-utils_src_configure
}

src_test() {
	pushd "${CMAKE_BUILD_DIR}" > /dev/null
	Xemake test || die "tests failed"
	popd > /dev/null
}

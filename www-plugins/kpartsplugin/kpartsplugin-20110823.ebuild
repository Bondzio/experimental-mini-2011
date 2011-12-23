# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-plugins/kpartsplugin/kpartsplugin-20110823.ebuild,v 1.1 2011/12/18 22:55:13 dilfridge Exp $

EAPI=3
inherit kde4-base nsplugins

DESCRIPTION="Plugin using KDE's KParts technology to embed file viewers into non-KDE browsers"
HOMEPAGE="http://www.unix-ag.uni-kl.de/~fischer/kpartsplugin/"
SRC_URI="http://www.unix-ag.uni-kl.de/~fischer/kpartsplugin/${P}.tar.bz2"

LICENSE="GPL-3 BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE=""

src_prepare() {
	echo "set( PLUGIN_INSTALL_DIR \"/usr/$(get_libdir)/${PLUGINS_DIR}/\" )" >> CMakeLists.txt || die
	kde4-base_src_prepare
}
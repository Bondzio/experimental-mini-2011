# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/eselect-postgresql/eselect-postgresql-1.1.2.ebuild,v 1.1 2013/06/16 20:58:36 titanofold Exp $

EAPI="5"

DESCRIPTION="Utility to select the default PostgreSQL slot"
HOMEPAGE="http://www.gentoo.org/"
SRC_URI="http://dev.gentoo.org/~titanofold/${P}.tbz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~ppc-macos ~x86-solaris"
IUSE=""

RDEPEND="app-admin/eselect"

src_install() {
	keepdir /etc/eselect/postgresql

	insinto /usr/share/eselect/modules
	doins postgresql.eselect

	dosym /usr/bin/eselect /usr/bin/postgresql-config
}

pkg_postinst() {
	postgresql-config update
}

# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/lockfile-progs/lockfile-progs-0.1.17.ebuild,v 1.1 2012/12/31 20:23:57 phajdan.jr Exp $

EAPI="5"

inherit toolchain-funcs

DESCRIPTION="Programs to safely lock/unlock files and mailboxes"
HOMEPAGE="http://packages.debian.org/sid/lockfile-progs"
SRC_URI="mirror://debian/pool/main/l/${PN}/${PN}_${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~mips ~ppc ~s390 ~sh ~sparc ~x86"
IUSE=""

DEPEND="net-libs/liblockfile"
RDEPEND="${DEPEND}"

src_prepare() {
	# Provide better Makefile, with clear separation between compilation
	# and installation.
	cp "${FILESDIR}/Makefile" . || die
}

src_compile() {
	tc-export CC
	default
}

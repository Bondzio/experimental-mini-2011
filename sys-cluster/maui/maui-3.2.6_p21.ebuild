# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-cluster/maui/maui-3.2.6_p21.ebuild,v 1.4 2011/09/06 08:23:37 jlec Exp $

inherit autotools eutils multilib

DESCRIPTION="Maui Cluster Scheduler"
HOMEPAGE="http://www.clusterresources.com/pages/products/maui-cluster-scheduler.php"
SRC_URI="http://www.clusterresources.com/downloads/maui/${P/_/}.tar.gz"
IUSE=""
DEPEND="sys-cluster/torque"
RDEPEND="${DEPEND}"
SLOT="0"
LICENSE="maui"
KEYWORDS="~x86 ~amd64"
RESTRICT="fetch mirror"

S="${WORKDIR}/${P/_/}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${PV}-autoconf-2.60-compat.patch
	sed -i \
		-e "s~BUILDROOT=~BUILDROOT=${D}~" \
		"${S}"/Makefile.in
	eautoreconf
}

src_compile() {
	econf --with-spooldir=/usr/spool/maui || die
	emake || die
}

src_install() {
	make install INST_DIR="${D}/usr"
	cd docs
	dodoc README mauidocs.html
}

pkg_nofetch() {
	einfo "Please visit ${HOMEPAGE}, obtain the file"
	einfo "${P/_/}.tar.gz and put it in ${DISTDIR}"
}

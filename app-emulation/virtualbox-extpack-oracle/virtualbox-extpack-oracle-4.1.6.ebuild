# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/virtualbox-extpack-oracle/virtualbox-extpack-oracle-4.1.6.ebuild,v 1.1 2011/11/04 23:08:17 polynomial-c Exp $

EAPI=2

inherit eutils

MY_PN="Oracle_VM_VirtualBox_Extension_Pack"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="PUEL extensions for VirtualBox"
HOMEPAGE="http://www.virtualbox.org/"
SRC_URI="http://download.virtualbox.org/virtualbox/${PV}/${MY_P}.vbox-extpack -> ${MY_P}.tar.gz"

LICENSE="PUEL"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror strip"

RDEPEND="~app-emulation/virtualbox-${PV}"

src_install() {
	insinto /usr/$(get_libdir)/virtualbox/ExtensionPacks/${MY_PN}
	doins -r linux.${ARCH}
	doins ExtPack* PXE-Intel.rom
}
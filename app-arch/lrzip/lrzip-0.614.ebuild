# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/lrzip/lrzip-0.614.ebuild,v 1.7 2013/05/19 16:37:12 aballier Exp $

EAPI=4

DESCRIPTION="Long Range ZIP or Lzma RZIP optimized for compressing large files"
HOMEPAGE="http://ck.kolivas.org/apps/lrzip/README"
SRC_URI="http://ck.kolivas.org/apps/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ppc ~ppc64 ~sparc ~x86 ~amd64-fbsd ~x86-fbsd"
IUSE=""

RDEPEND="dev-libs/lzo
	 app-arch/bzip2
	 sys-libs/zlib"
DEPEND="${RDEPEND}
	x86? ( dev-lang/nasm )
	virtual/perl-PodParser"

src_configure() {
	econf --docdir="/usr/share/doc/${P}"
}

src_install() {
	default
	rm "${D}/usr/share/doc/${P}/COPYING"
}

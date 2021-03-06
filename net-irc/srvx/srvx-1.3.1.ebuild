# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-irc/srvx/srvx-1.3.1.ebuild,v 1.2 2012/11/18 18:44:13 ago Exp $

inherit eutils

DESCRIPTION="A complete set of services for IRCu 2.10.10+ and bahamut based networks"
HOMEPAGE="http://www.srvx.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="bahamut debug"

src_compile() {
	local PROTOCOL="p10" MALLOC="system" DEBUG=""
	use bahamut && PROTOCOL="bahamut"
	use debug && MALLOC="srvx" DEBUG="--enable-debug"

	econf \
		--with-protocol=${PROTOCOL} \
		--with-malloc=${MALLOC} \
		--enable-modules=helpserv,memoserv,sockcheck \
		${DEBUG} \
		|| die "econf failed"
	emake all-recursive || die "emake failed"
}

src_install() {
	dobin src/srvx || die "dobin failed"
	dodir /var/lib/srvx || die "dodir failed"

	insinto /etc/srvx
	newins srvx.conf.example srvx.conf || die "newins failed"
	newins sockcheck.conf.example sockcheck.conf || die "newins failed"
	dosym ../../../etc/srvx/srvx.conf /var/lib/srvx/srvx.conf || die "dosym failed"
	dosym ../../../etc/srvx/sockcheck.conf /var/lib/srvx/sockcheck.conf || die "dosym failed"

	insinto /usr/share/srvx
	for helpfile in \
		chanserv.help global.help mod-helpserv.help mod-memoserv.help \
		mod-sockcheck.help modcmd.help nickserv.help opserv.help \
		saxdb.help sendmail.help
	do
		doins "src/${helpfile}" || die "doins failed"
		dosym "../../../usr/share/srvx/${helpfile}" "/var/lib/srvx/${helpfile}" || die "dosym failed"
	done

	dodoc \
		AUTHORS INSTALL NEWS README TODO UPGRADE \
		{sockcheck,srvx}.conf.example \
		|| die "dodoc failed"

	newinitd "${FILESDIR}"/srvx.init.d srvx || die "newinitd failed"
	newconfd "${FILESDIR}"/srvx.conf.d srvx || die "newconfd failed"
}

pkg_setup() {
	enewgroup srvx
	enewuser srvx -1 -1 /var/lib/srvx srvx
}

pkg_postinst() {
	chown -R srvx:srvx "${ROOT}"/etc/srvx "${ROOT}"/var/lib/srvx
	chmod 0700 "${ROOT}"/etc/srvx "${ROOT}"/var/lib/srvx
}

# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sec-policy/selinux-nagios/selinux-nagios-9999.ebuild,v 1.1 2012/10/13 16:30:58 swift Exp $
EAPI="4"

IUSE=""
MODS="nagios"
BASEPOL="9999"

inherit selinux-policy-2

DESCRIPTION="SELinux policy for nagios"

KEYWORDS=""
DEPEND="${DEPEND}
	sec-policy/selinux-apache
"
RDEPEND="${DEPEND}"

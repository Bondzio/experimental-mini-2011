# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sec-policy/selinux-dracut/selinux-dracut-2.20120725-r11.ebuild,v 1.2 2013/02/23 17:24:51 swift Exp $
EAPI="4"

IUSE=""
MODS="dracut"
BASEPOL="2.20120725-r9"

inherit selinux-policy-2

DESCRIPTION="SELinux policy for dracut"

KEYWORDS="amd64 x86"

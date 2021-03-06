# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-leechcraft/lc-laure/lc-laure-9999.ebuild,v 1.1 2013/03/08 22:00:34 maksbotan Exp $

EAPI="4"

inherit leechcraft

DESCRIPTION="VLC-based audio/video player for LeechCraft"

SLOT="0"
KEYWORDS=""
IUSE="debug"

DEPEND="~app-leechcraft/lc-core-${PV}
	sys-apps/file
	>=media-video/vlc-2.0.0"
RDEPEND="${DEPEND}"

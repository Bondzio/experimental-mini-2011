# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-leechcraft/lc-gmailnotifier/lc-gmailnotifier-0.5.98.ebuild,v 1.1 2013/07/03 16:00:33 maksbotan Exp $

EAPI="5"

inherit leechcraft

DESCRIPTION="Notifier about new mail in a GMail inbox for LeechCraft"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug notify quark"

DEPEND="~app-leechcraft/lc-core-${PV}
	dev-qt/qtdeclarative:4"
RDEPEND="${DEPEND}
	quark? ( ~virtual/leechcraft-quark-sideprovider-${PV} )
	notify? ( ~virtual/leechcraft-notifier-${PV} )"

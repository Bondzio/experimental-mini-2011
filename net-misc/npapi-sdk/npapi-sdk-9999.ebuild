# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/npapi-sdk/npapi-sdk-9999.ebuild,v 1.7 2012/06/18 14:57:57 mgorny Exp $

EAPI=4

#if LIVE
AUTOTOOLS_AUTORECONF=yes
EGIT_REPO_URI="https://bitbucket.org/mgorny/${PN}.git"

inherit git-2
#endif

inherit autotools-utils

DESCRIPTION="NPAPI headers bundle"
HOMEPAGE="https://bitbucket.org/mgorny/npapi-sdk/"
SRC_URI="mirror://bitbucket/mgorny/${PN}/downloads/${P}.tar.bz2"

LICENSE="MPL-1.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE=""
#if LIVE

KEYWORDS=""
SRC_URI=
#endif

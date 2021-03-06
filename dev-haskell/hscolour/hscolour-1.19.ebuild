# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-haskell/hscolour/hscolour-1.19.ebuild,v 1.7 2012/11/18 13:40:00 gienah Exp $

EAPI=4

CABAL_FEATURES="bin lib profile haddock"
inherit base haskell-cabal

DESCRIPTION="Colourise Haskell code."
HOMEPAGE="http://code.haskell.org/~malcolm/hscolour/"
SRC_URI="mirror://hackage/packages/archive/${PN}/${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ia64 ppc ppc64 sparc x86 ~x86-fbsd"
IUSE=""

RDEPEND=">=dev-lang/ghc-6.6.1"
DEPEND="${RDEPEND}
		>=dev-haskell/cabal-1.6"

PATCHES=("${FILESDIR}/${PN}-1.19-ghc-7.5.patch")

src_install() {
	cabal_src_install
	if use doc; then
		dohtml hscolour.css
	fi
}

# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-mathematics/jags/jags-3.3.0.ebuild,v 1.4 2013/02/21 13:32:18 jlec Exp $

EAPI=4

inherit autotools-utils toolchain-funcs

MYP="JAGS-${PV}"

DESCRIPTION="Just Another Gibbs Sampler for Bayesian MCMC simulation"
HOMEPAGE="http://www-fis.iarc.fr/~martyn/software/jags/"
SRC_URI="mirror://sourceforge/project/mcmc-jags/JAGS/3.x/Source/${MYP}.tar.gz"
LICENSE="GPL-2"
IUSE="doc"

SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"

RDEPEND="
	virtual/blas
	virtual/lapack"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? (
		virtual/latex-base
		dev-texlive/texlive-latexextra
		)"

S="${WORKDIR}/${MYP}"

src_configure() {
	myeconfargs=(
		--with-blas="$($(tc-getPKG_CONFIG) --libs blas)"
		--with-lapack="$($(tc-getPKG_CONFIG) --libs lapack)"
	)
	autotools-utils_src_configure
}

src_compile() {
	autotools-utils_src_compile all $(use doc && echo docs)
}

src_install() {
	autotools-utils_src_install
	use doc && dodoc ${AUTOTOOLS_BUILD_DIR}/doc/manual/*.pdf
}

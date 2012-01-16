# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-mathematics/octave/octave-3.4.3-r1.ebuild,v 1.1 2012/01/03 02:24:04 bicatali Exp $

EAPI=4
inherit eutils base autotools

DESCRIPTION="High-level interactive language for numerical computations"
LICENSE="GPL-3"
HOMEPAGE="http://www.octave.org/"
SRC_URI="ftp://ftp.gnu.org/pub/gnu/${PN}/${P}.tar.bz2"

SLOT="0"
IUSE="curl doc fftw +glpk +imagemagick opengl +qhull +qrupdate readline +sparse X zlib"
KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~ppc64 ~sparc ~x86"

RDEPEND="dev-libs/libpcre
	app-text/ghostscript-gpl
	sys-libs/ncurses
	virtual/lapack
	curl? ( net-misc/curl )
	fftw? ( sci-libs/fftw:3.0 )
	glpk? ( sci-mathematics/glpk )
	imagemagick? ( || (
			media-gfx/graphicsmagick[cxx]
			media-gfx/imagemagick[cxx] ) )
	opengl? (
		media-libs/freetype:2
		media-libs/fontconfig
		>=x11-libs/fltk-1.3:1[opengl] )
	qhull? ( media-libs/qhull )
	qrupdate? ( sci-libs/qrupdate )
	sparse? (
		sci-libs/camd
		sci-libs/ccolamd
		sci-libs/cholmod
		sci-libs/colamd
		sci-libs/cxsparse
		sci-libs/umfpack )
	X? ( x11-libs/libX11 )
	zlib? ( sys-libs/zlib )"

DEPEND="${RDEPEND}
	doc? (
		virtual/latex-base
		dev-texlive/texlive-genericrecommended
		sys-apps/texinfo )
	dev-util/pkgconfig"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-3.4.0-{pkgbuilddir,help}.patch
	eautoreconf
}

src_configure() {
	# hdf5 disabled because not really useful (bug #299876)
	econf \
		--localstatedir="${EPREFIX}/var/state/octave" \
		--enable-shared \
		--without-hdf5 \
		--with-blas="$(pkg-config --libs blas)" \
		--with-lapack="$(pkg-config --libs lapack)" \
		$(use_enable doc docs) \
		$(use_enable readline) \
		$(use_with curl) \
		$(use_with fftw fftw3) \
		$(use_with fftw fftw3f) \
		$(use_with glpk) \
		$(use_with imagemagick magick) \
		$(use_with opengl) \
		$(use_with qhull) \
		$(use_with qrupdate) \
		$(use_with sparse umfpack) \
		$(use_with sparse colamd) \
		$(use_with sparse ccolamd) \
		$(use_with sparse cholmod) \
		$(use_with sparse cxsparse) \
		$(use_with X x) \
		$(use_with zlib z)
}

src_install() {
	default
	use doc && dodoc $(find doc -name \*.pdf)
	[[ -e test/fntests.log ]] && dodoc test/fntests.log
	echo "LDPATH=${EPREFIX}/usr/$(get_libdir)/${P}" > 99octave
	doenvd 99octave
}
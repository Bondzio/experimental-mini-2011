# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-chemistry/ball/ball-1.4.1-r1.ebuild,v 1.4 2013/05/29 16:17:06 jlec Exp $

EAPI=5

PYTHON_COMPAT=( python2_5 python2_6 python2_7 )

inherit cmake-utils python-single-r1

DESCRIPTION="Biochemical Algorithms Library"
HOMEPAGE="http://www.ball-project.org/"
SRC_URI="http://dev.gentoo.org/~jlec/distfiles/${P}.tar.gz"

SLOT="0"
LICENSE="LGPL-2 GPL-3"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="cuda mpi +python sql +threads +webkit"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	dev-cpp/eigen:3
	dev-libs/boost
	dev-qt/qtcore:4
	dev-qt/qtgui:4
	dev-qt/qtopengl:4
	dev-qt/qttest:4
	dev-qt/qtwebkit:4
	media-libs/glew
	sci-libs/fftw:3.0[threads?]
	sci-libs/gsl
	sci-libs/libsvm
	sci-mathematics/lpsolve
	virtual/opengl
	x11-libs/libX11
	cuda? ( dev-util/nvidia-cuda-toolkit )
	mpi? ( virtual/mpi )
	python? ( ${PYTHON_DEPS} )
	sql? ( dev-qt/qtsql:4 )
	webkit? ( dev-qt/qtwebkit:4 )"
DEPEND="${RDEPEND}
	dev-python/sip
	sys-devel/bison
	virtual/yacc"

S="${WORKDIR}"/BALL

PATCHES=(
	"${FILESDIR}"/${P}-multilib.patch
	"${FILESDIR}"/${P}-libsvm.patch
	"${FILESDIR}"/${P}-pthread.patch
	"${FILESDIR}"/${P}-python.patch
	"${FILESDIR}"/${P}-missing-signed.patch
	"${FILESDIR}"/${P}-gcc-4.7.patch
	"${FILESDIR}"/${P}-BondOrder.xml.patch
	"${FILESDIR}"/${P}-Fixed-the-FPT-version-of-bond-order-assignment-2.patch
	"${FILESDIR}"/${P}-Added-MAX_PENALTY-option-to-bond-order-assignment.patch
	"${FILESDIR}"/${P}-Fixed-a-bug-in-the-AssignBondOrderProcessor.patch
	"${FILESDIR}"/${P}-Fix-compilation-of-Python-bindings-with-new-sip-vers.patch
	)

pkg_setup() {
	use python \
		&& python_set_active_version 2 \
		&& python_pkg_setup
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_use threads FFTW_THREADS)
		$(cmake-utils_use cuda MT_ENABLE_CUDA)
		$(cmake-utils_use mpi MT_ENABLE_MPI)
		$(cmake-utils_use sql BALL_HAS_QTSQL)
		$(cmake-utils_use_use webkit USE_QTWEBKIT)
		$(cmake-utils_use python BALL_PYTHON_SUPPORT)
	)
	cmake-utils_src_configure
	local i
	for i in "${S}"/data/*; do
		ln -sf "${i}" "${BUILD_DIR}"/source/TEST/ || die
		ln -sf "${i}" "${S}"/source/TEST/ || die
	done
}

src_compile() {
	cmake-utils_src_compile
	use test && cmake-utils_src_make build_tests
}

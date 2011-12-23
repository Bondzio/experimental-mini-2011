# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/guppy/guppy-0.1.9-r2.ebuild,v 1.1 2011/12/20 15:16:14 maksbotan Exp $

EAPI="3"
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.* *-jython"
DISTUTILS_USE_SEPARATE_SOURCE_DIRECTORIES="1"

inherit distutils

DESCRIPTION="Guppy-PE -- A Python Programming Environment"
HOMEPAGE="http://guppy-pe.sourceforge.net/ http://pypi.python.org/pypi/guppy"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=""

PYTHON_CFLAGS=("2.* + -fno-strict-aliasing")

DOCS="ANNOUNCE ChangeLog"

src_prepare() {
	distutils_src_prepare
	preparation() {
		if [[ ${PYTHON_ABI} == "2.7" ]]; then
			sed -e 's:_PyLong_AsScaledDouble:_PyLong_Frexp:' -i src/sets/bitset.c || die
		fi
	}
	python_execute_function -s preparation
}

src_test() {
	testing() {
		"$(PYTHON)" setup.py build -b "build-${PYTHON_ABI}" install --home="${T}/test-${PYTHON_ABI}" || die "Installation of tests failed with Python ${PYTHON_ABI}"
		cd "${T}/test-${PYTHON_ABI}/lib/python"
		PYTHONPATH="$(ls -d "${BUILDDIR}/build-${PYTHON_ABI}/"lib*):." "$(PYTHON)" guppy/heapy/test/test_all.py || return 1
	}
	python_execute_function -s testing
}

src_install() {
	distutils_src_install
	dohtml guppy/doc/*

	delete_duplicated_documentation() {
		find "${D}$(python_get_sitedir)" -name '*.html' -o -name '*.jpg' | xargs rm -f
	}
	python_execute_function -q delete_duplicated_documentation
}
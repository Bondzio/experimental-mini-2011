# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/asciitable/asciitable-0.8.0-r1.ebuild,v 1.2 2013/04/24 21:05:37 bicatali Exp $

EAPI=5

PYTHON_COMPAT=( python{2_5,2_6,2_7,3_1,3_2,3_3} )

inherit distutils-r1

DESCRIPTION="An extensible ASCII table reader"
HOMEPAGE="http://cxc.harvard.edu/contrib/asciitable"
SRC_URI="mirror://pypi/a/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"

RDEPEND="dev-python/numpy[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	test? ( dev-python/nose[${PYTHON_USEDEP}] )"

python_test() {
	nosetests || die "Tests fail with ${EPYTHON}"
}

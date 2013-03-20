# Distributed under the terms of the GNU General Public License v2

EAPI=5
PYTHON_COMPAT=( python{2_5,2_6,2_7} )

inherit distutils-r1

DESCRIPTION="A lightweight wrapper around MySQLdb. Originally part of the Tornado framework."
HOMEPAGE="http://torndb.readthedocs.org/ http://pypi.python.org/pypi/torndb"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-python/mysql-python"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

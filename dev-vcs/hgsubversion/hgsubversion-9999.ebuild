# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="5-progress"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="3.* *-jython *-pypy-*"

inherit distutils mercurial

DESCRIPTION="hgsubversion is a Mercurial extension for working with Subversion repositories."
HOMEPAGE="https://bitbucket.org/durin42/hgsubversion https://pypi.python.org/pypi/hgsubversion"
SRC_URI=""
EHG_REPO_URI="https://bitbucket.org/durin42/hgsubversion"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="test"

RDEPEND="$(python_abi_depend ">=dev-vcs/mercurial-1.4")
	$(python_abi_depend -i "2.5" ">=dev-vcs/subversion-1.5[python]")
	|| (
		$(python_abi_depend -e "2.5" dev-python/subvertpy)
		$(python_abi_depend -e "2.5" ">=dev-vcs/subversion-1.5[python]")
	)"
DEPEND="${RDEPEND}
	$(python_abi_depend dev-python/setuptools)
	test? ( $(python_abi_depend dev-python/nose) )"

DOCS="README"

src_test() {
	cd tests

	testing() {
		python_execute PYTHONPATH="../build-${PYTHON_ABI}/lib" "$(PYTHON)" run.py
	}
	python_execute_function testing
}

# Copyright 2008-2012 Funtoo Technologies
# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit eutils

# Major version
#MV=${PV/\.*}
MV=current

DESCRIPTION="Advanced Policy Firewall (APF) is an iptables (netfilter) based firewall system"
HOMEPAGE="http://www.rfxn.com/projects/advanced-policy-firewall/"
SRC_URI="http://www.rfxn.com/downloads/apf-${MV}.tar.gz -> apf-current.tar.gz"

LICENSE=""
SLOT="0"
KEYWORDS="~*"
IUSE=""

RESTRICT="mirror strip"

RDEPEND="
        net-firewall/iptables
"

S="${WORKDIR}/apf-${MV}"

pkg_setup() {
        elog "This ebuild installs the apf Firewall on top of iptables."
        elog
}

src_install() {
pwd
#        insinto /usr/local/apf/

#        insinto /usr/local/bin
#        dobin apf

#        make_desktop_entry ${PN} apf ${PN}
}


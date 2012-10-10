# Copyright 2008-2012 Funtoo Technologies
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

DESCRIPTION="Pooler's multi-threaded CPU miner for Litecoin and Bitcoin, fork of Jeff Garzik's reference cpuminer"
HOMEPAGE="https://github.com/pooler/cpuminer/"
SRC_URI="https://github.com/downloads/pooler/cpuminer/${P}.tar.gz"
MY_P="cpuminer-${PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~*"
IUSE=""

DEPEND="net-misc/curl"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}

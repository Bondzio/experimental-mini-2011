# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/PEAR-HTML_QuickForm2/PEAR-HTML_QuickForm2-0.6.1.ebuild,v 1.1 2012/01/15 11:07:58 mabi Exp $

inherit php-pear-r1

DESCRIPTION="The PEAR::HTML_QuickForm package provides methods for creating, validating, processing HTML forms."
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-lang/php-5.1.4"
RDEPEND="${DEPEND}
	>=dev-php/PEAR-HTML_Common2-2.0.0_beta1"
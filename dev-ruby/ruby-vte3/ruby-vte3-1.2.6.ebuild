# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ruby-vte3/ruby-vte3-1.2.6.ebuild,v 1.1 2013/05/04 16:45:00 naota Exp $

EAPI=4
USE_RUBY="ruby19"

inherit ruby-ng-gnome2

DESCRIPTION="Ruby VTE bindings"
KEYWORDS="~amd64"
IUSE=""

DEPEND="${DEPEND} x11-libs/vte:2.90"
RDEPEND="${RDEPEND} x11-libs/vte:2.90"

ruby_add_bdepend ">=dev-ruby/ruby-glib2-${PV}"
ruby_add_rdepend ">=dev-ruby/ruby-gtk3-${PV}"

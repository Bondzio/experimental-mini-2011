# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/bacon/bacon-1.2.0.ebuild,v 1.1 2013/02/23 10:38:08 graaff Exp $

EAPI=5
USE_RUBY="ruby18 ruby19 ree18 jruby"

RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="ChangeLog README.rdoc"

inherit ruby-fakegem

DESCRIPTION="Small RSpec clone weighing less than 350 LoC"
HOMEPAGE="http://chneukirchen.org/repos/bacon"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/rack-test/rack-test-0.6.2.ebuild,v 1.2 2013/01/16 01:03:21 zerochaos Exp $

EAPI=4
USE_RUBY="ruby18 ruby19 ree18"

# no documentation is generable, it needs hanna, which is broken
RUBY_FAKEGEM_TASK_DOC=""

RUBY_FAKEGEM_RECIPE_TEST="rspec"

RUBY_FAKEGEM_EXTRADOC="History.txt README.rdoc"

inherit versionator ruby-fakegem

DESCRIPTION="Rack::Test is a small, simple testing API for Rack apps."
HOMEPAGE="http://github.com/brynary/rack-test"

LICENSE="MIT"
SLOT="$(get_version_component_range 1-2)"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

ruby_add_rdepend '>=dev-ruby/rack-1.0'
ruby_add_bdepend "
	test? ( >=dev-ruby/sinatra-1.2.6 )"

all_ruby_prepare() {
	rm Gemfile* || die
	sed -i -e '/bundler/d' spec/spec_helper.rb || die
}

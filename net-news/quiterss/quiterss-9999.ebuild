# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-news/quiterss/quiterss-9999.ebuild,v 1.8 2013/07/03 19:36:48 maksbotan Exp $

EAPI=5

PLOCALES="ar cs de el_GR es fa fr hu it ja ko lt nl pl pt_BR pt_PT ru sk sr sv tg_TJ th tr uk vi zh_CN zh_TW"
EHG_REPO_URI="https://code.google.com/p/quite-rss"
inherit l10n qt4-r2 mercurial

DESCRIPTION="A Qt4-based RSS/Atom feed reader"
HOMEPAGE="http://code.google.com/p/quite-rss/"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="debug"

DEPEND="dev-db/sqlite:3
	dev-qt/qtcore:4
	dev-qt/qtgui:4
	dev-qt/qtsql:4[sqlite]
	dev-qt/qtwebkit:4"
RDEPEND="${DEPEND}"

DOCS=( AUTHORS HISTORY_EN HISTORY_RU README )

src_prepare() {
	my_rm_loc() {
		sed -i -e "s:lang/${PN}_${1}.ts::" lang/lang.pri || die 'sed on lang.pri failed'
	}
	# dedicated english locale file is not installed at all
	rm "lang/${PN}_en.ts" || die "remove of lang/${PN}_en.ts failed"

	l10n_find_plocales_changes "lang" "${PN}_" '.ts'
	l10n_for_each_disabled_locale_do my_rm_loc

	qt4-r2_src_prepare
}

src_configure() {
	eqmake4 PREFIX="${EPREFIX}/usr"
}

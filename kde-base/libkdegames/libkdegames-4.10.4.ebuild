# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/libkdegames/libkdegames-4.10.4.ebuild,v 1.5 2013/07/02 08:07:03 ago Exp $

EAPI=5

inherit kde4-base

DESCRIPTION="Base library common to many KDE games."
KEYWORDS="amd64 ~arm ppc ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="debug openal"

DEPEND="
	openal? (
		media-libs/libsndfile
		media-libs/openal
	)
"
RDEPEND="${DEPEND}"

KMSAVELIBS="true"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use openal USE_OPENAL_SNDFILE)
	)

	kde4-base_src_configure
}

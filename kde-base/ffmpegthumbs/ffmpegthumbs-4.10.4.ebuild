# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/ffmpegthumbs/ffmpegthumbs-4.10.4.ebuild,v 1.5 2013/07/02 08:06:43 ago Exp $

EAPI=5

inherit kde4-base

DESCRIPTION="A FFmpeg based thumbnail Generator for Video Files."
KEYWORDS="amd64 ~arm ppc ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="debug"

DEPEND="
	virtual/ffmpeg
"
RDEPEND="${DEPEND}"

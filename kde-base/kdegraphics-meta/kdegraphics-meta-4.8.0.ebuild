# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdegraphics-meta/kdegraphics-meta-4.8.0.ebuild,v 1.1 2012/01/25 18:16:45 johu Exp $

EAPI=4
inherit kde4-meta-pkg

DESCRIPTION="kdegraphics - merge this to pull in all kdegraphics-derived packages"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="scanner"

RDEPEND="
	$(add_kdebase_dep gwenview)
	$(add_kdebase_dep kamera)
	$(add_kdebase_dep kcolorchooser)
	$(add_kdebase_dep kdegraphics-mobipocket)
	$(add_kdebase_dep kdegraphics-strigi-analyzer)
	$(add_kdebase_dep kgamma)
	$(add_kdebase_dep kolourpaint)
	$(add_kdebase_dep kruler)
	$(add_kdebase_dep ksnapshot)
	$(add_kdebase_dep libkdcraw)
	$(add_kdebase_dep libkexiv2)
	$(add_kdebase_dep libkipi)
	$(add_kdebase_dep okular)
	$(add_kdebase_dep svgpart)
	$(add_kdebase_dep thumbnailers)
	scanner? (
		$(add_kdebase_dep ksaneplugin)
		$(add_kdebase_dep libksane)
	)
"
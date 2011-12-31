# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdelibs/kdelibs-4.7.4-r10.ebuild,v 1.1 2011/12/28 22:07:07 dilfridge Exp $

EAPI=4

CPPUNIT_REQUIRED="optional"
DECLARATIVE_REQUIRED="always"
OPENGL_REQUIRED="optional"
KDE_SCM="git"
inherit kde4-base fdo-mime toolchain-funcs

DESCRIPTION="KDE libraries needed by all KDE programs."
HOMEPAGE="http://www.kde.org/"

KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~x86-fbsd ~amd64-linux ~x86-linux"
LICENSE="LGPL-2.1"
IUSE="3dnow acl alsa altivec bindist +bzip2 debug doc fam +handbook jpeg2k kerberos
lzma mmx nls openexr +policykit semantic-desktop spell sse sse2 ssl +udev
+udisks +upower upnp zeroconf"

REQUIRED_USE="
	udisks? ( udev )
	upower? ( udev )
"

# needs the kate regression testsuite from svn
RESTRICT="test"

COMMONDEPEND="
	app-crypt/qca:2
	>=app-misc/strigi-0.7.6
	app-text/docbook-xml-dtd:4.2
	app-text/docbook-xsl-stylesheets
	>=dev-libs/libattica-0.1.90
	>=dev-libs/libdbusmenu-qt-0.3.2
	dev-libs/libpcre[unicode]
	dev-libs/libxml2
	dev-libs/libxslt
	media-libs/fontconfig
	media-libs/freetype:2
	media-libs/giflib
	>=media-libs/libpng-1.4
	>=media-libs/phonon-4.4.3
	sys-libs/zlib
	virtual/jpeg
	>=x11-misc/shared-mime-info-0.60
	acl? ( virtual/acl )
	alsa? ( media-libs/alsa-lib )
	!aqua? (
		x11-libs/libICE
		x11-libs/libSM
		x11-libs/libX11
		x11-libs/libXau
		x11-libs/libXcursor
		x11-libs/libXdmcp
		x11-libs/libXext
		x11-libs/libXfixes
		x11-libs/libXft
		x11-libs/libXpm
		x11-libs/libXrender
		x11-libs/libXScrnSaver
		x11-libs/libXtst
		!kernel_SunOS? ( sys-libs/libutempter )
	)
	bzip2? ( app-arch/bzip2 )
	fam? ( virtual/fam )
	jpeg2k? ( media-libs/jasper )
	kerberos? ( virtual/krb5 )
	lzma? ( app-arch/xz-utils )
	openexr? (
		media-libs/openexr
		media-libs/ilmbase
	)
	policykit? ( >=sys-auth/polkit-qt-0.99 )
	semantic-desktop? (
		>=dev-libs/shared-desktop-ontologies-0.6.50
		>=dev-libs/soprano-2.6.51[dbus,raptor,redland]
	)
	spell? ( app-text/enchant )
	ssl? ( dev-libs/openssl )
	udev? ( sys-fs/udev )
	upnp? ( media-libs/herqq )
	zeroconf? (
		|| (
			net-dns/avahi[mdnsresponder-compat]
			!bindist? ( net-misc/mDNSResponder )
		)
	)
"
DEPEND="${COMMONDEPEND}
	doc? ( app-doc/doxygen )
	nls? ( virtual/libintl )
"
RDEPEND="${COMMONDEPEND}
	!x11-libs/qt-phonon
	>=app-crypt/gnupg-2.0.11
	app-misc/ca-certificates
	$(add_kdebase_dep kde-env)
	!aqua? (
		x11-apps/iceauth
		x11-apps/rgb
		>=x11-misc/xdg-utils-1.0.2-r3
		udisks? ( sys-fs/udisks )
		upower? ( sys-power/upower )
	)
"
PDEPEND="
	$(add_kdebase_dep katepart)
	|| ( ( $(add_kdebase_dep kfmclient) ) x11-misc/xdg-utils )
	handbook? ( $(add_kdebase_dep khelpcenter) )
	policykit? (
		>=kde-misc/polkit-kde-kcmodules-0.98_pre20101127
		>=sys-auth/polkit-kde-agent-0.99
	)
	semantic-desktop? ( $(add_kdebase_dep nepomuk) )
"

# Force the upgrade of plasma-workspace to a version that explicitly depends on kactivities
add_blocker plasma-workspace 4.7.1

# file collision, bug 394991
add_blocker kcontrol 4.4.50

PATCHES=(
	"${FILESDIR}/dist/01_gentoo_set_xdg_menu_prefix-1.patch"
	"${FILESDIR}/dist/02_gentoo_append_xdg_config_dirs-1.patch"
	"${FILESDIR}/${PN}-4.5.90-mimetypes.patch"
	"${FILESDIR}/${PN}-4.4.90-xslt.patch"
	"${FILESDIR}/${PN}-4.6.3-no_suid_kdeinit.patch"
	"${FILESDIR}/${PN}-4.6.3-bytecode.patch"
)

pkg_pretend() {
	if [[ ${MERGE_TYPE} != binary ]]; then
		[[ $(gcc-major-version) -lt 4 ]] || \
				( [[ $(gcc-major-version) -eq 4 && $(gcc-minor-version) -le 3 ]] ) \
			&& die "Sorry, but gcc-4.3 and earlier won't work for KDE SC 4.6 (see bug #354837)."
	fi
}

src_prepare() {
	kde4-base_src_prepare
	use arm && epatch "${FILESDIR}/${PN}-4.6.2-armlinking.patch"

	# Rename applications.menu (needs 01_gentoo_set_xdg_menu_prefix-1.patch to work)
	sed -e 's|FILES[[:space:]]applications.menu|FILES applications.menu RENAME kde-4-applications.menu|g' \
		-i kded/CMakeLists.txt || die "Sed on CMakeLists.txt for applications.menu failed."

	if use aqua; then
		sed -i -e \
			"s:BUNDLE_INSTALL_DIR \"/Applications:BUNDLE_INSTALL_DIR \"${EPREFIX}/${APP_BUNDLE_DIR}:g" \
			cmake/modules/FindKDE4Internal.cmake || die "failed to sed FindKDE4Internal.cmake"

		#if [[ ${CHOST} == *-darwin8 ]]; then
		sed -i -e \
			"s:set(_add_executable_param MACOSX_BUNDLE):remove(_add_executable_param MACOSX_BUNDLE):g" \
			cmake/modules/KDE4Macros.cmake || die "failed to sed KDE4Macros.cmake"
		#fi

		# solid/solid/backends/iokit doesn't properly link, so disable it.
		sed -e "s|\(APPLE\)|(FALSE)|g" -i solid/solid/CMakeLists.txt \
			|| die "disabling solid/solid/backends/iokit failed"
		sed -e "s|m_backend = .*Backends::IOKit.*;|m_backend = 0;|g" -i solid/solid/managerbase.cpp \
			|| die "disabling solid/solid/backends/iokit failed"

		# There's no fdatasync on OSX and the check fails to detect that.
		sed -e "/HAVE_FDATASYNC/ d" -i config.h.cmake \
			|| die "disabling fdatasync failed"

		# Fix nameser include to nameser8_compat
		sed -e "s|nameser8_compat.h|nameser_compat.h|g" -i kio/misc/kpac/discovery.cpp \
			|| die "fixing nameser include failed"
		append-flags -DHAVE_ARPA_NAMESER8_COMPAT_H=1

		# Try to fix kkeyserver_mac
		epatch "${FILESDIR}"/${PN}-4.3.80-kdeui_util_kkeyserver_mac.patch
	fi

	if [[ ${CHOST} == *-solaris* ]] ; then
		epatch "${FILESDIR}/kdelibs-4.3.2-solaris-ksyscoca.patch"
		# getgrouplist not in solaris libc
		epatch "${FILESDIR}/kdelibs-4.3.2-solaris-getgrouplist.patch"
		# solaris has no d_type element in dir_ent
		epatch "${FILESDIR}/kdelibs-4.3.2-solaris-fileunix.patch"
	fi
}

src_configure() {
	if use zeroconf; then
		if has_version net-dns/avahi; then
			mycmakeargs=(-DWITH_Avahi=ON -DWITH_DNSSD=OFF)
		elif has_version net-misc/mDNSResponder; then
			mycmakeargs=(-DWITH_Avahi=OFF -DWITH_DNSSD=ON)
		else
			die "USE=\"zeroconf\" enabled but neither net-dns/avahi nor net-misc/mDNSResponder were found."
		fi
	else
		mycmakeargs=(-DWITH_Avahi=OFF -DWITH_DNSSD=OFF)
	fi
	mycmakeargs+=(
		-DWITH_HSPELL=OFF
		-DWITH_ASPELL=OFF
		-DKDE_DEFAULT_HOME=.kde4
		-DKAUTH_BACKEND=POLKITQT-1
		-DBUILD_libkactivities=OFF
		$(cmake-utils_use_build handbook doc)
		$(cmake-utils_use_has 3dnow X86_3DNOW)
		$(cmake-utils_use_has altivec PPC_ALTIVEC)
		$(cmake-utils_use_has mmx X86_MMX)
		$(cmake-utils_use_has sse X86_SSE)
		$(cmake-utils_use_has sse2 X86_SSE2)
		$(cmake-utils_use_with acl)
		$(cmake-utils_use_with alsa)
		$(cmake-utils_use_with bzip2 BZip2)
		$(cmake-utils_use_with fam)
		$(cmake-utils_use_with jpeg2k Jasper)
		$(cmake-utils_use_with kerberos GSSAPI)
		$(cmake-utils_use_with lzma LibLZMA)
		$(cmake-utils_use_with nls Libintl)
		$(cmake-utils_use_with openexr OpenEXR)
		$(cmake-utils_use_with opengl OpenGL)
		$(cmake-utils_use_with policykit PolkitQt-1)
		$(cmake-utils_use_with semantic-desktop Soprano)
		$(cmake-utils_use_with semantic-desktop SharedDesktopOntologies)
		$(cmake-utils_use_with spell ENCHANT)
		$(cmake-utils_use_with ssl OpenSSL)
		$(cmake-utils_use_with udev UDev)
		$(cmake-utils_use_with upnp HUpnp)
	)
	kde4-base_src_configure
}

src_compile() {
	kde4-base_src_compile

	# The building of apidox is not managed anymore by the build system
	if use doc; then
		einfo "Building API documentation"
		cd "${S}"/doc/api/
		./doxygen.sh "${S}" || die "APIDOX generation failed"
	fi
}

src_install() {
	kde4-base_src_install

	# use system certificates
	rm -f "${ED}"/usr/share/apps/kssl/ca-bundle.crt || die
	dosym /etc/ssl/certs/ca-certificates.crt /usr/share/apps/kssl/ca-bundle.crt

	if use doc; then
		einfo "Installing API documentation. This could take a bit of time."
		cd "${S}"/doc/api/
		docinto /HTML/en/kdelibs-apidox
		dohtml -r ${P}-apidocs/*
	fi

	if use aqua; then
		einfo "fixing ${PN} plugins"

		local _PV=${PV:0:3}.0
		local _dir=${EPREFIX}/usr/$(get_libdir)/kde4/plugins/script

		install_name_tool -id \
			"${_dir}/libkrossqtsplugin.${_PV}.dylib" \
			"${D}/${_dir}/libkrossqtsplugin.${_PV}.dylib" \
			|| die "failed fixing libkrossqtsplugin.${_PV}.dylib"

		einfo "fixing ${PN} cmake detection files"
		#sed -i -e \
		#	"s:if (HAVE_XKB):if (HAVE_XKB AND NOT APPLE):g" \
		echo -e "set(XKB_FOUND FALSE)\nset(HAVE_XKB FALSE)" > \
			"${ED}"/usr/share/apps/cmake/modules/FindXKB.cmake \
			|| die "failed fixing FindXKB.cmake"
	fi

	einfo Installing environment file.
	# Since 44qt4 is sourced earlier QT_PLUGIN_PATH is defined.
	echo "COLON_SEPARATED=QT_PLUGIN_PATH" > "${T}/77kde"
	echo "QT_PLUGIN_PATH=${EPREFIX}/usr/$(get_libdir)/kde4/plugins" >> "${T}/77kde"
	doenvd "${T}/77kde"
}

pkg_postinst() {
	fdo-mime_mime_database_update

	if use zeroconf; then
		echo
		elog "To make zeroconf support available in KDE make sure that the 'mdnsd' daemon"
		elog "is running."
		echo
		einfo "If you also want to use zeroconf for hostname resolution, emerge sys-auth/nss-mdns"
		einfo "and enable multicast dns lookups by editing the 'hosts:' line in /etc/nsswitch.conf"
		einfo "to include 'mdns', e.g.:"
		einfo "	hosts: files mdns dns"
		echo
	fi

	elog "Your homedir is set to \${HOME}/.kde4"
	echo

	kde4-base_pkg_postinst
}

pkg_prerm() {
	# Remove ksycoca4 global database
	rm -f "${EROOT}${PREFIX}"/share/kde4/services/ksycoca4
}

pkg_postrm() {
	fdo-mime_mime_database_update

	kde4-base_pkg_postrm
}
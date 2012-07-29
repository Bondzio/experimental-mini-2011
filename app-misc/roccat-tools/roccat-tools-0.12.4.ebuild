# Distributed under the terms of the GNU General Public License v2

EAPI="4"

inherit cmake-utils linux-info

DESCRIPTION="Use Roccat devices under Linux"
HOMEPAGE="http://sourceforge.net/projects/roccat/"
SRC_URI="mirror://sourceforge/roccat/${P}.tar.bz2"
LICENSE="GPL-2 CCPL-Attribution-3.0"

SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="mirror"
IUSE="
    roccat-arvo
    roccat-isku
    roccat-kone
    roccat-koneplus
    roccat-kovaplus
    roccat-pyra
    roccat-savu
"

RDEPEND="
    x11-libs/gtk+:2
    x11-libs/libnotify
    media-libs/libcanberra
    virtual/libusb
    dev-libs/libunique
    dev-libs/dbus-glib
    sys-fs/udev[gudev]
"

pkg_unpack() {
    linux-info_pkg_setup
    elog "Checkking for ROCCAT support..."

    if !(linux_chkconfig_module HID_ROCCAT); then
	eerror "You must enable ROCCAT support (as module) in your kernel."
	eerror ""
	eerror "Device Drivers -> HID support -> Special HID drivers -> Roccat device support = m"
	eerror ""
	eerror "roccat-tools will not work without this."
    fi
}

src_configure() {
    local myconf

    use roccat-arvo && myconf="${myconf};arvo"
    use roccat-isku && myconf="${myconf};isku"
    use roccat-kone && myconf="${myconf};kone"
    use roccat-koneplus && myconf="${myconf};koneplus"
    use roccat-kovaplus && myconf="${myconf};kovaplus"
    use roccat-pyra && myconf="${myconf};pyra"
    use roccat-savu && myconf="${myconf};savu"

    mycmakeargs=( -DCMAKE_INSTALL_PREFIX="/usr" -DDEVICES="${myconf}" )
    cmake-utils_src_configure
}

pkg_postinst() {
    enewgroup roccat
    elog "You must be in the roccat group to use roccat-tools."
    elog "Start 'roccatgui' to start using roccat-tools."
    elog ""
    elog "Your must reload your udev rules:"
    elog "	Run 'udevadm control --reload-rules && udevadm trigger --subsystem-match=usb'"
    elog ""
}

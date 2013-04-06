# Distributed under the terms of the GNU General Public License v2

EAPI=2

DESCRIPTION="Virtual to select between sys-fs/udev and sys-fs/eudev"
HOMEPAGE=""
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS="~*"
# These default enabled IUSE flags should follow defaults of sys-fs/udev.
IUSE="gudev +hwdb introspection keymap +kmod selinux static-libs"

DEPEND=""
RDEPEND="|| ( >=sys-fs/udev-197-r3[gudev?,hwdb?,introspection?,keymap?,kmod?,selinux?,static-libs?]
	kmod? ( >=sys-fs/eudev-1_beta1[modutils,gudev?,hwdb?,introspection?,keymap?,selinux?,static-libs?] )
	!kmod? ( >=sys-fs/eudev-1_beta1[gudev?,hwdb?,introspection?,keymap?,selinux?,static-libs?] )
	)"

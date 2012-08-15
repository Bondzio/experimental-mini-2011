EAPI="4"
inherit eutils flag-o-matic toolchain-funcs multilib

DESCRIPTION="mdev from busybox."
HOMEPAGE="http://www.busybox.net/"

base='busybox'
MY_P=${base}-${PV/_/-}

SRC_URI="http://www.busybox.net/downloads/${MY_P}.tar.bz2"
KEYWORDS="~*"

LICENSE="GPL-2"
SLOT="0"
IUSE="static"
RESTRICT="test"

RDEPEND="!sys-apps/busybox[mdev]"

DEPEND="${RDEPEND}
	>=sys-kernel/linux-headers-2.6.39"

S=${WORKDIR}/${MY_P}

src_configure() {
	cat >"${S}/tmp.config" <<-END_OF_CONFIG
		CONFIG_HAVE_DOT_CONFIG=y
		CONFIG_USE_PORTABLE_CODE=y
		CONFIG_PLATFORM_LINUX=y
		CONFIG_FEATURE_BUFFERS_USE_MALLOC=y
		CONFIG_SHOW_USAGE=y
		CONFIG_FEATURE_VERBOSE_USAGE=y
		CONFIG_FEATURE_COMPRESS_USAGE=y
		CONFIG_UNICODE_SUPPORT=y
		CONFIG_FEATURE_CHECK_UNICODE_IN_ENV=y
		CONFIG_UNICODE_COMBINING_WCHARS=y
		CONFIG_UNICODE_WIDE_WCHARS=y
		CONFIG_LONG_OPTS=y
		CONFIG_FEATURE_DEVPTS=y
		CONFIG_LFS=y
		CONFIG_NO_DEBUG_LIB=y
		CONFIG_INSTALL_APPLET_SYMLINKS=y
		CONFIG_MDEV=y
		CONFIG_FEATURE_MDEV_CONF=y
		CONFIG_FEATURE_MDEV_RENAME=y
		CONFIG_FEATURE_MDEV_RENAME_REGEXP=y
		CONFIG_FEATURE_MDEV_EXEC=y
		CONFIG_FEATURE_MDEV_LOAD_FIRMWARE=y
		CONFIG_FEATURE_SH_IS_NONE=y
		CONFIG_FEATURE_BASH_IS_NONE=y"
END_OF_CONFIG

	if use static; then
		echo 'CONFIG_STATIC=y' >> "${S}/tmp.config"
	fi

	# Landley's miniconfig. <3
	make KCONFIG_ALLCONFIG='tmp.config' allnoconfig >/dev/null 2>&1
}

src_install() {
	mkdir "${D}/sbin" || die
	cp busybox "${D}/sbin/mdev" || die
	chmod 750 "${D}/sbin/mdev" || die
	dodir /etc/mdev
	dodir /etc/mdev/helpers
	keepdir /etc/mdev
	keepdir /etc/mdev/helpers
	# copy basic mdev config to /etc
	cp "${FILESDIR}"/mdev.conf "${D}/etc/"
	# copy help scripts to /etc/mdev/helpers
	cp -a "${FILESDIR}"/1.20.2/* "${D}/etc//mdev/helpers/"
	newinitd "${FILESDIR}"/mdev.init mdev || die
}
add_init() {
    local runl=$1
    if [ ! -e ${ROOT}/etc/runlevels/${runl} ]
    then
        install -d -m0755 ${ROOT}/etc/runlevels/${runl}
    fi
    for initd in $*
    do
        # if the initscript is not going to be installed and  is not currently installed, return
        [[ -e ${D}/etc/init.d/${initd} || -e ${ROOT}/etc/init.d/${initd} ]] || continue
        [[ -e ${ROOT}/etc/runlevels/${runl}/${initd} ]] && continue
        elog "Auto-adding '${initd}' service to your ${runl} runlevel"
        ln -snf /etc/init.d/${initd} "${ROOT}"/etc/runlevels/${runl}/${initd}
    done
}

pkg_postinst() {
add_init sysinit mdev
}


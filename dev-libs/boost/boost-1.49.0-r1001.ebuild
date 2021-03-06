# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="5-progress"
PYTHON_DEPEND="python? ( <<>> )"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="*-jython *-pypy-*"

inherit eutils flag-o-matic multilib multiprocessing python toolchain-funcs versionator

MY_P=${PN}_$(replace_all_version_separators _)

DESCRIPTION="Boost Libraries for C++"
HOMEPAGE="http://www.boost.org/"
SRC_URI="mirror://sourceforge/boost/${MY_P}.tar.bz2"

LICENSE="Boost-1.0"
MAJOR_V="$(get_version_component_range 1-2)"
SLOT="0"
KEYWORDS="*"
IUSE="debug doc elibc_glibc icu mpi python static-libs tools"

RDEPEND="elibc_glibc? ( <sys-libs/glibc-2.16 )
	icu? ( >=dev-libs/icu-3.6:0= )
	mpi? ( || ( sys-cluster/openmpi[cxx] sys-cluster/mpich2[cxx,threads] ) )
	app-arch/bzip2:0=
	sys-libs/zlib:0=
	!app-admin/eselect-boost"
DEPEND="${RDEPEND}
	=dev-util/boost-build-${MAJOR_V}*"

S=${WORKDIR}/${MY_P}

MAJOR_PV=$(replace_all_version_separators _ ${MAJOR_V})
BJAM="b2-${MAJOR_PV}"

create_user-config.jam() {
	local compiler compiler_version compiler_executable

	if [[ ${CHOST} == *-darwin* ]]; then
		compiler="darwin"
		compiler_version="$(gcc-fullversion)"
		compiler_executable="$(tc-getCXX)"
	else
		compiler="gcc"
		compiler_version="$(gcc-version)"
		compiler_executable="$(tc-getCXX)"
	fi
	local mpi_configuration python_configuration

	if use mpi; then
		mpi_configuration="using mpi ;"
	fi

	if use python; then
		python_configuration="using python : $(python_get_version) : /usr : $(python_get_includedir) : /usr/$(get_libdir) ;"
	fi

	# The debug-symbols=none and optimization=none are not official upstream flags but a Gentoo
	# specific patch to make sure that all our CFLAGS/CXXFLAGS/LDFLAGS are being respected.
	# Using optimization=off would for example add "-O0" and override "-O2" set by the user.
	# Please take a look at the boost-build ebuild for more information.
	cat > user-config.jam << __EOF__
variant gentoorelease : release : <optimization>none <debug-symbols>none ;
variant gentoodebug : debug : <optimization>none ;

using ${compiler} : ${compiler_version} : ${compiler_executable} : <cflags>"${CFLAGS}" <cxxflags>"${CXXFLAGS}" <linkflags>"${LDFLAGS}" ;
${mpi_configuration}
${python_configuration}
__EOF__
}

pkg_setup() {
	if use python; then
		python_pkg_setup
	fi
}

src_prepare() {
	epatch "${FILESDIR}/${PN}-1.48.0-mpi_python3.patch"
	epatch "${FILESDIR}/${PN}-1.48.0-respect_python-buildid.patch"
	epatch "${FILESDIR}/${PN}-1.48.0-support_dots_in_python-buildid.patch"
	epatch "${FILESDIR}/${PN}-1.48.0-no_strict_aliasing_python2.patch"
	epatch "${FILESDIR}/${PN}-1.48.0-disable_libboost_python3.patch"
	epatch "${FILESDIR}/${PN}-1.48.0-python_linking.patch"
	epatch "${FILESDIR}/${PN}-1.48.0-disable_icu_rpath.patch"
	epatch "${FILESDIR}/remove-toolset-1.48.0.patch"
}

src_configure() {
	OPTIONS=""

	if [[ ${CHOST} == *-darwin* ]]; then
		# We need to add the prefix, and in two cases this exceeds, so prepare
		# for the largest possible space allocation.
		append-ldflags -Wl,-headerpad_max_install_names
	fi

	# bug 298489
	if use ppc || use ppc64; then
		[[ $(gcc-version) > 4.3 ]] && append-flags -mno-altivec
	fi

	use icu && OPTIONS+=" -sICU_PATH=/usr"
	use icu || OPTIONS+=" --disable-icu boost.locale.icu=off"
	use mpi || OPTIONS+=" --without-mpi"
	use python || OPTIONS+=" --without-python"

	# https://svn.boost.org/trac/boost/attachment/ticket/2597/add-disable-long-double.patch
	if use sparc || { use mips && [[ ${ABI} = "o32" ]]; } || use hppa || use arm || use x86-fbsd || use sh; then
		OPTIONS+=" --disable-long-double"
	fi

	OPTIONS+=" pch=off --boost-build=/usr/share/boost-build-${MAJOR_PV} --prefix=\"${D}usr\" --layout=versioned"

	if use static-libs; then
		LINK_OPTS="link=shared,static"
		LIBRARY_TARGETS="*.a *$(get_libname)"
	else
		LINK_OPTS="link=shared"
		# There is no dynamically linked version of libboost_test_exec_monitor and libboost_exception.
		LIBRARY_TARGETS="libboost_test_exec_monitor*.a libboost_exception*.a *$(get_libname)"
	fi
}

src_compile() {
	export BOOST_ROOT="${S}"
	PYTHON_DIRS=""
	MPI_PYTHON_MODULE=""
	NUMJOBS="-j$(makeopts_jobs)"

	building() {
		create_user-config.jam

		einfo "Using the following command to build:"
		einfo "${BJAM} ${NUMJOBS} -q -d+2 gentoorelease --user-config=user-config.jam ${OPTIONS} threading=single,multi ${LINK_OPTS} runtime-link=shared $(use python && echo --python-buildid=${PYTHON_ABI})"

		${BJAM} ${NUMJOBS} -q -d+2 \
			gentoorelease \
			--user-config=user-config.jam \
			${OPTIONS} \
			threading=single,multi ${LINK_OPTS} runtime-link=shared \
			$(use python && echo --python-buildid=${PYTHON_ABI}) \
			|| die "Building of Boost libraries failed"

		# ... and do the whole thing one more time to get the debug libs
		if use debug; then
			einfo "Using the following command to build:"
			einfo "${BJAM} ${NUMJOBS} -q -d+2 gentoodebug --user-config=user-config.jam ${OPTIONS} threading=single,multi ${LINK_OPTS} runtime-link=shared --buildid=debug $(use python && echo --python-buildid=${PYTHON_ABI})"

			${BJAM} ${NUMJOBS} -q -d+2 \
				gentoodebug \
				--user-config=user-config.jam \
				${OPTIONS} \
				threading=single,multi ${LINK_OPTS} runtime-link=shared \
				--buildid=debug \
				$(use python && echo --python-buildid=${PYTHON_ABI}) \
				|| die "Building of Boost debug libraries failed"
		fi

		if use python; then
			if [[ -z "${PYTHON_DIRS}" ]]; then
				PYTHON_DIRS="$(find bin.v2/libs -name python | sort)"
			else
				if [[ "${PYTHON_DIRS}" != "$(find bin.v2/libs -name python | sort)" ]]; then
					die "Inconsistent structure of build directories"
				fi
			fi

			local dir
			for dir in ${PYTHON_DIRS}; do
				mv ${dir} ${dir}-${PYTHON_ABI} || die "Renaming of '${dir}' to '${dir}-${PYTHON_ABI}' failed"
			done

			if use mpi; then
				if [[ -z "${MPI_PYTHON_MODULE}" ]]; then
					MPI_PYTHON_MODULE="$(find bin.v2/libs/mpi/build/*/gentoorelease -name mpi.so)"
					if [[ "$(echo "${MPI_PYTHON_MODULE}" | wc -l)" -ne 1 ]]; then
						die "Multiple mpi.so files found"
					fi
				else
					if [[ "${MPI_PYTHON_MODULE}" != "$(find bin.v2/libs/mpi/build/*/gentoorelease -name mpi.so)" ]]; then
						die "Inconsistent structure of build directories"
					fi
				fi

				mv stage/lib/mpi.so stage/lib/mpi.so-${PYTHON_ABI} || die "Renaming of 'stage/lib/mpi.so' to 'stage/lib/mpi.so-${PYTHON_ABI}' failed"
			fi
		fi
	}
	if use python; then
		python_execute_function building
	else
		building
	fi

	if use tools; then
		pushd tools > /dev/null || die
		einfo "Using the following command to build the tools:"
		einfo "${BJAM} ${NUMJOBS} -q -d+2 gentoorelease --user-config=../user-config.jam ${OPTIONS}"

		${BJAM} ${NUMJOBS} -q -d+2\
			gentoorelease \
			--user-config=../user-config.jam \
			${OPTIONS} \
			|| die "Building of Boost tools failed"
		popd > /dev/null || die
	fi
}

src_install () {
	installation() {
		create_user-config.jam

		if use python; then
			local dir
			for dir in ${PYTHON_DIRS}; do
				cp -pr ${dir}-${PYTHON_ABI} ${dir} || die "Copying of '${dir}-${PYTHON_ABI}' to '${dir}' failed"
			done

			if use mpi; then
				cp -p stage/lib/mpi.so-${PYTHON_ABI} "${MPI_PYTHON_MODULE}" || die "Copying of 'stage/lib/mpi.so-${PYTHON_ABI}' to '${MPI_PYTHON_MODULE}' failed"
				cp -p stage/lib/mpi.so-${PYTHON_ABI} stage/lib/mpi.so || die "Copying of 'stage/lib/mpi.so-${PYTHON_ABI}' to 'stage/lib/mpi.so' failed"
			fi
		fi

		einfo "Using the following command to install:"
		einfo "${BJAM} -q -d+2 gentoorelease --user-config=user-config.jam ${OPTIONS} threading=single,multi ${LINK_OPTS} runtime-link=shared --includedir=\"${D}usr/include\" --libdir=\"${D}usr/$(get_libdir)\" $(use python && echo --python-buildid=${PYTHON_ABI}) install"

		${BJAM} -q -d+2 \
			gentoorelease \
			--user-config=user-config.jam \
			${OPTIONS} \
			threading=single,multi ${LINK_OPTS} runtime-link=shared \
			--includedir="${D}usr/include" \
			--libdir="${D}usr/$(get_libdir)" \
			$(use python && echo --python-buildid=${PYTHON_ABI}) \
			install || die "Installation of Boost libraries failed"

		if use debug; then
			einfo "Using the following command to install:"
			einfo "${BJAM} -q -d+2 gentoodebug --user-config=user-config.jam ${OPTIONS} threading=single,multi ${LINK_OPTS} runtime-link=shared --includedir=\"${D}usr/include\" --libdir=\"${D}usr/$(get_libdir)\" --buildid=debug $(use python && echo --python-buildid=${PYTHON_ABI})"

			${BJAM} -q -d+2 \
				gentoodebug \
				--user-config=user-config.jam \
				${OPTIONS} \
				threading=single,multi ${LINK_OPTS} runtime-link=shared \
				--includedir="${D}usr/include" \
				--libdir="${D}usr/$(get_libdir)" \
				--buildid=debug \
				$(use python && echo --python-buildid=${PYTHON_ABI}) \
				install || die "Installation of Boost debug libraries failed"
		fi

		if use python; then
			rm -r ${PYTHON_DIRS} || die

			# Move mpi.so Python module to Python site-packages directory.
			# https://svn.boost.org/trac/boost/ticket/2838
			if use mpi; then
				dodir $(python_get_sitedir)/boost
				mv "${D}usr/$(get_libdir)/mpi.so" "${D}$(python_get_sitedir)/boost" || die
				cat << EOF > "${D}$(python_get_sitedir)/boost/__init__.py" || die
import sys
if sys.platform.startswith('linux'):
	import DLFCN
	flags = sys.getdlopenflags()
	sys.setdlopenflags(DLFCN.RTLD_NOW | DLFCN.RTLD_GLOBAL)
	from . import mpi
	sys.setdlopenflags(flags)
	del DLFCN, flags
else:
	from . import mpi
del sys
EOF
			fi
		fi
	}
	if use python; then
		python_execute_function installation
	else
		installation
	fi

	mv "${D}usr/include/boost-${MAJOR_PV}/boost" "${D}usr/include/boost" || die
	rmdir "${D}usr/include/boost-${MAJOR_PV}" || die

	use python || rm -rf "${D}usr/include/boost/python"* || die

	if use doc; then
		find libs/*/* -iname "test" -or -iname "src" | xargs rm -rf
		dohtml \
			-A pdf,txt,cpp,hpp \
			*.{htm,html,png,css} \
			-r doc
		dohtml \
			-A pdf,txt \
			-r tools
		insinto /usr/share/doc/${PF}/html
		doins -r libs
		doins -r more

		# To avoid broken links
		insinto /usr/share/doc/${PF}/html
		doins LICENSE_1_0.txt

		dosym /usr/include/boost /usr/share/doc/${PF}/html/boost
	fi

	pushd "${D}usr/$(get_libdir)" > /dev/null || die

	# The threading and MPI libraries always have the "-mt" (multithreading) tag.
	# Create symlinks for packages expecting libraries without the "-mt" tag.

	if use static-libs; then
		THREAD_LIBS="libboost_thread-mt-${MAJOR_PV}.a libboost_thread-mt-${MAJOR_PV}$(get_libname)"
	else
		THREAD_LIBS="libboost_thread-mt-${MAJOR_PV}$(get_libname)"
	fi
	local lib
	for lib in ${THREAD_LIBS}; do
		dosym ${lib} "/usr/$(get_libdir)/${lib/-mt/}"
	done

	if use mpi; then
		if use static-libs; then
			MPI_LIBS="libboost_mpi-mt-${MAJOR_PV}.a libboost_mpi-mt-${MAJOR_PV}$(get_libname)"
		else
			MPI_LIBS="libboost_mpi-mt-${MAJOR_PV}$(get_libname)"
		fi
		local lib
		for lib in ${MPI_LIBS}; do
			dosym ${lib} "/usr/$(get_libdir)/${lib/-mt/}"
		done
	fi

	if use debug; then
		if use static-libs; then
			THREAD_DEBUG_LIBS="libboost_thread-mt-${MAJOR_PV}-debug$(get_libname) libboost_thread-mt-${MAJOR_PV}-debug.a"
		else
			THREAD_DEBUG_LIBS="libboost_thread-mt-${MAJOR_PV}-debug$(get_libname)"
		fi

		local lib
		for lib in ${THREAD_DEBUG_LIBS}; do
			dosym ${lib} "/usr/$(get_libdir)/${lib/-mt/}"
		done

		if use mpi; then
			if use static-libs; then
				MPI_DEBUG_LIBS="libboost_mpi-mt-${MAJOR_PV}-debug.a libboost_mpi-mt-${MAJOR_PV}-debug$(get_libname)"
			else
				MPI_DEBUG_LIBS="libboost_mpi-mt-${MAJOR_PV}-debug$(get_libname)"
			fi

			local lib
			for lib in ${MPI_DEBUG_LIBS}; do
				dosym ${lib} "/usr/$(get_libdir)/${lib/-mt/}"
			done
		fi
	fi

	local f
	for f in $(ls -1 ${LIBRARY_TARGETS} | grep -v debug); do
		dosym ${f} /usr/$(get_libdir)/${f/-${MAJOR_PV}}
	done

	if use debug; then
		dodir /usr/$(get_libdir)/boost-debug
		local f
		for f in $(ls -1 ${LIBRARY_TARGETS} | grep debug); do
			dosym ../${f} /usr/$(get_libdir)/boost-debug/${f/-${MAJOR_PV}-debug}
		done
	fi

	popd > /dev/null || die

	if use tools; then
		dobin dist/bin/*

		pushd dist > /dev/null || die
		insinto /usr/share
		doins -r share/boostbook
		popd > /dev/null || die
	fi

	# boost's build system truely sucks for not having a destdir.  Because for
	# this reason we are forced to build with a prefix that includes the
	# DESTROOT, dynamic libraries on Darwin end messed up, referencing the
	# DESTROOT instread of the actual EPREFIX.  There is no way out of here
	# but to do it the dirty way of manually setting the right install_names.
	if [[ ${CHOST} == *-darwin* ]]; then
		einfo "Working around completely broken build-system(tm)"
		local d
		for d in "${ED}"usr/lib/*.dylib; do
			if [[ -f ${d} ]]; then
				# fix the "soname"
				ebegin "  correcting install_name of ${d#${ED}}"
				install_name_tool -id "/${d#${D}}" "${d}"
				eend $?
				# fix references to other libs
				refs=$(otool -XL "${d}" | \
					sed -e '1d' -e 's/^\t//' | \
					grep "^libboost_" | \
					cut -f1 -d' ')
				local r
				for r in ${refs}; do
					ebegin "    correcting reference to ${r}"
					install_name_tool -change \
						"${r}" \
						"${EPREFIX}/usr/lib/${r}" \
						"${d}"
					eend $?
				done
			fi
		done
	fi
}

pkg_preinst() {
	# /usr/include/boost and /usr/share/boostbook were symlinks to directories in older versions of Boost.
	local symlink
	for symlink in "${EROOT}usr/include/boost" "${EROOT}usr/share/boostbook"; do
		if [[ -L ${symlink} ]]; then
			rm -f "${symlink}" || die
		fi
	done
}

pkg_postinst() {
	if use mpi && use python; then
		python_mod_optimize boost
	fi
}

pkg_postrm() {
	if use mpi && use python; then
		python_mod_cleanup boost
	fi
}

# the tests will never fail because these are not intended as sanity
# tests at all. They are more a way for upstream to check their own code
# on new compilers. Since they would either be completely unreliable
# (failing for no good reason) or completely useless (never failing)
# there is no point in having them in the ebuild to begin with.
src_test() { :; }

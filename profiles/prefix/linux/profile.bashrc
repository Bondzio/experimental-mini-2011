# This is a ugly issue, see bug 289757 for origins
# This mimics the check in gcc ebuilds, bug 362315
#
# # Remember, bash treats floats like strings..

if [[ ${PN} == gcc && ${EBUILD_PHASE} == unpack ]]; then
    # Since 2.3 > 2.12 in numerical terms, just compare 2.X to 2.Y, will break
    # if >=3.0 is ever released
    VERS=$(/lib/libc.so.6 | head -n1 | grep -o "version [0-9]\.[0-9]" | cut -d. -f2 )
    if [[ $VERS -lt 12 ]]; then # compare host glibc 2.x to 2.12
        ewarn "Your host glibc is too old; disabling automatic fortify. bug 289757"
        GENTOO_PATCH_EXCLUDE="10_all_gcc-default-fortify-source.patch"
    fi
fi

# vim: set syn=sh expandtab ts=4:
# TODO: need to port all the dependencies first before finishing this port.
vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO sleuthkit/sleuthkit
    REF b42c1cf3c56c20cf3cb12d0ecf67af88aba24ed7
    SHA512 f22c279e70a48ad96c7c3aa49eaa9b83220aaf5c628e949bd214d34f0efbbda6824c166a62cf0e3a14e4ee44c0ee6abff20e4cfe7d4c092a2d30f543ff838d44
    HEAD_REF develop
    PATCHES
        remove-tools.patch
)

# TODO: maybe prevent this code duplication by iterating over the list of libraries
# TODO: needed to support the debug version of all the dependencies as well, currently it only uses the release binaries.
# This is because the debug directory doesn't have the include directories - only the binaries.
# Need to find a way to do this better.
vcpkg_list(SET options)
if("aff" IN_LIST FEATURES)
    vcpkg_list(APPEND options "--with-afflib=${CURRENT_INSTALLED_DIR}")
else()
    vcpkg_list(APPEND options "--without-afflib")
endif()


if("ewf" IN_LIST FEATURES)
    vcpkg_list(APPEND options "--with-libewf=${CURRENT_INSTALLED_DIR}")
else()
    vcpkg_list(APPEND options "--without-libewf")
endif()

if("vhdi" IN_LIST FEATURES)
    vcpkg_list(APPEND options "--with-libvhdi=${CURRENT_INSTALLED_DIR}")
else()
    vcpkg_list(APPEND options "--without-libvhdi")
endif()

if("vmdk" IN_LIST FEATURES)
    vcpkg_list(APPEND options "--with-libvmdk=${CURRENT_INSTALLED_DIR}")
else()
    vcpkg_list(APPEND options "--without-libvmdk")
endif()

if("lvm" IN_LIST FEATURES)
    vcpkg_list(APPEND options "--with-libvslvm=${CURRENT_INSTALLED_DIR}")
    vcpkg_list(APPEND options "--with-lbbfio=${CURRENT_INSTALLED_DIR}")
else()
    vcpkg_list(APPEND options "--without-libvslvm")
    vcpkg_list(APPEND options "--without-libbfio")
endif()


# TODO: add support for building TSK for windows, this only works for unix like platforms.
# Need to read tsk docs and follow them to add windows compilation support.
vcpkg_configure_make(
    SOURCE_PATH "${SOURCE_PATH}"
    AUTOCONFIG
    COPY_SOURCE
    OPTIONS 
        ${options}
        "--disable-java"
        "--disable-cppunit"
)

vcpkg_install_make()
vcpkg_fixup_pkgconfig()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")

file(GLOB LICENSE_FILES "${SOURCE_PATH}/licenses/*")
vcpkg_install_copyright(FILE_LIST ${LICENSE_FILES})
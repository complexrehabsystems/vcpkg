vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO complexrehabsystems/qhull
    HEAD_REF master
    PATCHES include-qhullcpp-shared.patch
)

string(COMPARE EQUAL "${VCPKG_LIBRARY_LINKAGE}" "static" BUILD_STATIC_LIBS)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS
        -DBUILD_STATIC_LIBS=${BUILD_STATIC_LIBS}
-DLINK_APPS_SHARED=ON
)

vcpkg_install_cmake()

file(REMOVE_RECURSE
    ${CURRENT_PACKAGES_DIR}/share/man
    ${CURRENT_PACKAGES_DIR}/share/doc
    ${CURRENT_PACKAGES_DIR}/debug/include
    ${CURRENT_PACKAGES_DIR}/debug/share/man
    ${CURRENT_PACKAGES_DIR}/debug/share/doc
)

vcpkg_fixup_cmake_targets(CONFIG_PATH lib/cmake/Qhull)
file(REMOVE
    ${CURRENT_PACKAGES_DIR}/lib/pkgconfig/qhullstatic.pc
    ${CURRENT_PACKAGES_DIR}/debug/lib/pkgconfig/qhullstatic_d.pc
)
if(VCPKG_LIBRARY_LINKAGE STREQUAL "static")
    file(REMOVE
        ${CURRENT_PACKAGES_DIR}/lib/pkgconfig/qhull_r.pc
        ${CURRENT_PACKAGES_DIR}/debug/lib/pkgconfig/qhull_rd.pc
    )
else()
    file(REMOVE
        ${CURRENT_PACKAGES_DIR}/lib/pkgconfig/qhullstatic_r.pc
        ${CURRENT_PACKAGES_DIR}/debug/lib/pkgconfig/qhullstatic_rd.pc
    )
endif()
vcpkg_fixup_pkgconfig()

#vcpkg_copy_tools(TOOL_NAMES
 #   qconvex
 #   qdelaunay
 #   qhalf
 #   qhull
 #   qvoronoi
 #   rbox
 #   AUTO_CLEAN
#)

file(INSTALL ${SOURCE_PATH}/README.txt DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT} RENAME copyright)

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/bin" "${CURRENT_PACKAGES_DIR}/debug/bin")


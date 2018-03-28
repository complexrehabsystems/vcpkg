include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO complexrehabsystems/librealsense
    REF d5c45866c0f866c1d08e4d4fb362dc291e64ee70
    SHA512 a6f3a6600358923d8231b9c135142d1b23619e965a073f8260c9b1e8e17db04a2e117692704c3484944ef256183005a35c3d1700f8365c6c0bdc427ec29d8790
    HEAD_REF crs-develop
)

string(COMPARE EQUAL "${VCPKG_LIBRARY_LINKAGE}" "dynamic" BUILD_LIBRARY_LINKAGE)
string(COMPARE EQUAL "${VCPKG_CRT_LINKAGE}" "static" BUILD_CRT_LINKAGE)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    OPTIONS
        -DENFORCE_METADATA=ON
        -DBUILD_EXAMPLES=OFF
        -DBUILD_GRAPHICAL_EXAMPLES=OFF
        -DBUILD_PYTHON_BINDINGS=OFF
        -DBUILD_UNIT_TESTS=OFF
        -DBUILD_WITH_OPENMP=OFF
        -DBUILD_SHARED_LIBS=${BUILD_LIBRARY_LINKAGE}
        -DBUILD_WITH_STATIC_CRT=${BUILD_CRT_LINKAGE}
        -DRGB_USING_AVX2=${RGB_USING_AVX2}
    OPTIONS_DEBUG
        "-DCMAKE_PDB_OUTPUT_DIRECTORY=${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-dbg"
        -DCMAKE_DEBUG_POSTFIX="_d"
)

vcpkg_install_cmake()

vcpkg_fixup_cmake_targets(CONFIG_PATH lib/cmake/realsense2)

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
# Handle copyright
file(COPY ${SOURCE_PATH}/COPYING DESTINATION ${CURRENT_PACKAGES_DIR}/share/realsense2)
file(RENAME ${CURRENT_PACKAGES_DIR}/share/realsense2/COPYING ${CURRENT_PACKAGES_DIR}/share/realsense2/copyright)

vcpkg_copy_pdbs()


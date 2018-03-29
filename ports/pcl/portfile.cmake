include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO complexrehabsystems/pcl
    REF 587ebc9d1989fe94aa0a29cd1a8fdb3abe518def
    SHA512 107465cd509dfd123b38c552ea4b2879344e3d0c8e33318a58c57f82af41bd13342b7f986b0ac8cef7c15d3178fb4f2e5b6fb57c48a636c2647f382c3ffb3e80
    HEAD_REF crs-develop
)

vcpkg_apply_patches(
    SOURCE_PATH ${SOURCE_PATH}
    PATCHES "${CMAKE_CURRENT_LIST_DIR}/cmakelists.patch"
            "${CMAKE_CURRENT_LIST_DIR}/config.patch"
            "${CMAKE_CURRENT_LIST_DIR}/config_install.patch"
            "${CMAKE_CURRENT_LIST_DIR}/find_flann.patch"
            "${CMAKE_CURRENT_LIST_DIR}/find_qhull.patch"
            "${CMAKE_CURRENT_LIST_DIR}/find_openni2.patch"
            "${CMAKE_CURRENT_LIST_DIR}/find_cuda.patch"
            "${CMAKE_CURRENT_LIST_DIR}/vs2017-15.4-workaround.patch"
)

string(COMPARE EQUAL "${VCPKG_LIBRARY_LINKAGE}" "dynamic" PCL_SHARED_LIBS)

set(WITH_OPENNI2 OFF)
if("openni2" IN_LIST FEATURES)
    set(WITH_OPENNI2 ON)
endif()

set(WITH_QT OFF)
if("qt" IN_LIST FEATURES)
    set(WITH_QT ON)
endif()

set(WITH_PCAP OFF)
if("pcap" IN_LIST FEATURES)
    set(WITH_PCAP ON)
endif()

set(WITH_CUDA OFF)
if("cuda" IN_LIST FEATURES)
    set(WITH_CUDA ON)
endif()

set(BUILD_TOOLS OFF)
if("tools" IN_LIST FEATURES)
    set(BUILD_TOOLS ON)
endif()

set(RSSDK2 OFF)
if("realsense2" IN_LIST FEATURES)
    set(WITH_RSSDK2 ON)
endif()

set(BUILD_APPS OFF)
set(BUILD_APPS_IN_HAND_SCANNER OFF)
if("crs" IN_LIST FEATURES)
    set(BUILD_APPS ON)
    set(BUILD_APPS_IN_HAND_SCANNER ON)
endif()

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS
        # BUILD
        -DBUILD_surface_on_nurbs=ON
        -DBUILD_tools=${BUILD_TOOLS}
        -DBUILD_CUDA=${WITH_CUDA}
        -DBUILD_GPU=${WITH_CUDA} # build GPU when use CUDA
        # PCL
        -DPCL_BUILD_WITH_BOOST_DYNAMIC_LINKING_WIN32=${PCL_SHARED_LIBS}
        -DPCL_BUILD_WITH_FLANN_DYNAMIC_LINKING_WIN32=${PCL_SHARED_LIBS}
        -DPCL_SHARED_LIBS=${PCL_SHARED_LIBS}
        # WITH
        -DWITH_CUDA=${WITH_CUDA}
        -DWITH_LIBUSB=OFF
        -DWITH_OPENNI2=${WITH_OPENNI2}
        -DWITH_PCAP=${WITH_PCAP}
        -DWITH_PNG=ON
        -DWITH_QHULL=ON
        -DWITH_QT=${WITH_QT}
        -DWITH_VTK=ON
        -DBUILD_APPS=ON
        -DBUILD_APPS_IN_HAND_SCANNER=ON
)

vcpkg_install_cmake()
vcpkg_fixup_cmake_targets(CONFIG_PATH share/pcl)
vcpkg_copy_pdbs()

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/share)

file(GLOB EXEFILES_RELEASE ${CURRENT_PACKAGES_DIR}/bin/*.exe)
file(GLOB EXEFILES_DEBUG ${CURRENT_PACKAGES_DIR}/debug/bin/*.exe)
file(COPY ${EXEFILES_RELEASE} DESTINATION ${CURRENT_PACKAGES_DIR}/bin)
file(COPY ${EXEFILES_DEBUG} DESTINATION ${CURRENT_PACKAGES_DIR}/debug/bin)
file(REMOVE ${EXEFILES_RELEASE} ${EXEFILES_DEBUG})


if(BUILD_TOOLS)
    file(GLOB EXEFILES_RELEASE ${CURRENT_PACKAGES_DIR}/bin/*.exe)
    file(GLOB EXEFILES_DEBUG ${CURRENT_PACKAGES_DIR}/debug/bin/*.exe)
    file(COPY ${EXEFILES_RELEASE} DESTINATION ${CURRENT_PACKAGES_DIR}/tools/pcl)
    file(REMOVE ${EXEFILES_RELEASE} ${EXEFILES_DEBUG})
    vcpkg_copy_tool_dependencies(${CURRENT_PACKAGES_DIR}/tools/pcl)
endif()

file(COPY ${SOURCE_PATH}/LICENSE.txt DESTINATION ${CURRENT_PACKAGES_DIR}/share/pcl)
file(RENAME ${CURRENT_PACKAGES_DIR}/share/pcl/LICENSE.txt ${CURRENT_PACKAGES_DIR}/share/pcl/copyright)

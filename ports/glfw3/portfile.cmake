include(vcpkg_common_functions)
set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/glfw-8138d057a9b1ee53b9800205f2320dba18bdfcb9)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO complexrehabsystems/glfw
    REF 8138d057a9b1ee53b9800205f2320dba18bdfcb9
    SHA512 ffa3c456bb71410c1ad7369ae9cacd4a18f21b9f17304aee07c147754a4d048286e71a15e17308778f5b4f1848e978e94ad58376054ec415cfb9f96cea7f2189
    HEAD_REF crs-attach-win32-window
)

if(NOT EXISTS ${SOURCE_PATH}/patch-config.stamp)
    message(STATUS "Patching src/glfw3Config.cmake.in")
    file(READ ${SOURCE_PATH}/src/glfw3Config.cmake.in CONFIG)
    string(REPLACE "\"@GLFW_LIB_NAME@\"" "NAMES @GLFW_LIB_NAME@ @GLFW_LIB_NAME@dll"
        CONFIG ${CONFIG}
    )
    string(REPLACE "@PACKAGE_CMAKE_INSTALL_PREFIX@" "@PACKAGE_CMAKE_INSTALL_PREFIX@/../.."
       CONFIG ${CONFIG}
    )
    file(WRITE ${SOURCE_PATH}/src/glfw3Config.cmake.in ${CONFIG})
    file(APPEND ${SOURCE_PATH}/src/glfw3Config.cmake.in "set(GLFW3_LIBRARIES \${GLFW3_LIBRARY})\n")
    file(WRITE ${SOURCE_PATH}/patch-config.stamp)
endif()

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    OPTIONS
        -DGLFW_BUILD_EXAMPLES=OFF
        -DGLFW_BUILD_TESTS=OFF
        -DGLFW_BUILD_DOCS=OFF
        -DPACKAGE_CMAKE_INSTALL_PREFIX=\${CMAKE_CURRENT_LIST_DIR}/../..
)

vcpkg_install_cmake()

file(MAKE_DIRECTORY ${CURRENT_PACKAGES_DIR}/share)
file(RENAME ${CURRENT_PACKAGES_DIR}/lib/cmake/glfw3 ${CURRENT_PACKAGES_DIR}/share/glfw3)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/lib/cmake)
file(READ ${CURRENT_PACKAGES_DIR}/share/glfw3/glfw3Targets.cmake _contents)
set(pattern "get_filename_component(_IMPORT_PREFIX \"\${_IMPORT_PREFIX}\" PATH)\n")
string(REPLACE "${pattern}${pattern}${pattern}" "${pattern}${pattern}" _contents "${_contents}")
file(WRITE ${CURRENT_PACKAGES_DIR}/share/glfw3/glfw3Targets.cmake ${_contents})

file(READ ${CURRENT_PACKAGES_DIR}/debug/lib/cmake/glfw3/glfw3Targets-debug.cmake _contents)
string(REPLACE "\${_IMPORT_PREFIX}" "\${_IMPORT_PREFIX}/debug" _contents "${_contents}")
file(WRITE ${CURRENT_PACKAGES_DIR}/share/glfw3/glfw3Targets-debug.cmake "${_contents}")
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/lib/cmake)

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)

file(COPY ${SOURCE_PATH}/LICENSE.md DESTINATION ${CURRENT_PACKAGES_DIR}/share/glfw3)
file(RENAME ${CURRENT_PACKAGES_DIR}/share/glfw3/LICENSE.md ${CURRENT_PACKAGES_DIR}/share/glfw3/copyright)
vcpkg_copy_pdbs()


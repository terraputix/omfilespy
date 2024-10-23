cmake_minimum_required(VERSION 3.15...3.29)

# There are some incompatibilities with Swift and gcc
# Therefore we have to specify explicitly to use clang
set(CMAKE_C_COMPILER "clang")
set(CMAKE_CXX_COMPILER "clang")

##########
# Python #
##########
# Scikit-build-core sets these values for you, or you can just hard-code the name and version.
project(
  ${SKBUILD_PROJECT_NAME}
  VERSION ${SKBUILD_PROJECT_VERSION}
  LANGUAGES CXX)

set(PYBIND11_FINDPYTHON ON)
find_package(pybind11 CONFIG REQUIRED)

#########
# SWIFT #
#########
# Add a custom target to build the Swift project, this will always be built!
add_custom_command(
    OUTPUT ${CMAKE_SOURCE_DIR}/../Swift/.build/debug/libOmFileInterface.a
    COMMAND swift build
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}/../Swift
    COMMENT "Building Swift static library"
    VERBATIM
)

# Create a custom target that depends on the output of the custom command
add_custom_target(BuildSwiftOmFiles ALL
    DEPENDS ${CMAKE_SOURCE_DIR}/../Swift/.build/debug/libOmFileInterface.a
)

add_library(OmFilesLib STATIC IMPORTED)
add_dependencies(OmFilesLib BuildSwiftOmFiles)
# IMPORTED_LOCATION needs to be an absolute path
set_target_properties(OmFilesLib PROPERTIES IMPORTED_LOCATION ${CMAKE_SOURCE_DIR}/../Swift/.build/debug/libOmFileInterface.a)

# Add a library using FindPython's tooling (pybind11 also provides a helper like this)
python_add_library(bindings MODULE bindings.cpp WITH_SOABI)
add_dependencies(bindings OmFilesLib)

# Set the Swift library path
set(SWIFT_LIB_PATH "/home/fred/Software/swift-6.0-RELEASE-fedora39/usr/lib/swift_static/linux")

add_library(libFoundationEssentials STATIC IMPORTED)
set_target_properties(libFoundationEssentials PROPERTIES IMPORTED_LOCATION ${SWIFT_LIB_PATH}/libFoundationEssentials.a)
add_library(libFoundation STATIC IMPORTED)
set_target_properties(libFoundation PROPERTIES IMPORTED_LOCATION ${SWIFT_LIB_PATH}/libFoundation.a)
add_library(libswift_StringProcessing STATIC IMPORTED)
set_target_properties(libswift_StringProcessing PROPERTIES IMPORTED_LOCATION ${SWIFT_LIB_PATH}/libswift_StringProcessing.a)
add_library(lib_FoundationCollections STATIC IMPORTED)
set_target_properties(lib_FoundationCollections PROPERTIES IMPORTED_LOCATION ${SWIFT_LIB_PATH}/lib_FoundationCollections.a)
add_library(libswiftGlibc STATIC IMPORTED)
set_target_properties(libswiftGlibc PROPERTIES IMPORTED_LOCATION ${SWIFT_LIB_PATH}/libswiftGlibc.a)
add_library(libswiftDispatch STATIC IMPORTED)
set_target_properties(libswiftDispatch PROPERTIES IMPORTED_LOCATION ${SWIFT_LIB_PATH}/libswiftDispatch.a)
add_library(libswiftSynchronization STATIC IMPORTED)
set_target_properties(libswiftSynchronization PROPERTIES IMPORTED_LOCATION ${SWIFT_LIB_PATH}/libswiftSynchronization.a)
add_library(lib_FoundationCShims STATIC IMPORTED)
set_target_properties(lib_FoundationCShims PROPERTIES IMPORTED_LOCATION ${SWIFT_LIB_PATH}/lib_FoundationCShims.a)
add_library(libswift_RegexParser STATIC IMPORTED)
set_target_properties(libswift_RegexParser PROPERTIES IMPORTED_LOCATION ${SWIFT_LIB_PATH}/libswift_RegexParser.a)
add_library(libdispatch STATIC IMPORTED)
set_target_properties(libdispatch PROPERTIES IMPORTED_LOCATION ${SWIFT_LIB_PATH}/libdispatch.a)
add_library(libBlocksRuntime STATIC IMPORTED)
set_target_properties(libBlocksRuntime PROPERTIES IMPORTED_LOCATION ${SWIFT_LIB_PATH}/libBlocksRuntime.a)
add_library(libCoreFoundation STATIC IMPORTED)
set_target_properties(libCoreFoundation PROPERTIES IMPORTED_LOCATION ${SWIFT_LIB_PATH}/libCoreFoundation.a)
add_library(libFoundationInternationalization STATIC IMPORTED)
set_target_properties(libFoundationInternationalization PROPERTIES IMPORTED_LOCATION ${SWIFT_LIB_PATH}/libFoundationInternationalization.a)
add_library(lib_FoundationICU STATIC IMPORTED)
set_target_properties(lib_FoundationICU PROPERTIES IMPORTED_LOCATION ${SWIFT_LIB_PATH}/lib_FoundationICU.a)

add_library(libswiftCore STATIC IMPORTED)
set_target_properties(libswiftCore PROPERTIES IMPORTED_LOCATION ${SWIFT_LIB_PATH}/libswiftCore.a)
add_library(libstdcxx SHARED IMPORTED)
set_target_properties(libstdcxx PROPERTIES IMPORTED_LOCATION /home/fred/anaconda3/lib/libstdc++.so)
add_library(libswiftSwiftOnoneSupport STATIC IMPORTED)
set_target_properties(libswiftSwiftOnoneSupport PROPERTIES IMPORTED_LOCATION ${SWIFT_LIB_PATH}/libswiftSwiftOnoneSupport.a)

target_link_libraries(bindings PRIVATE OmFilesLib)

target_link_libraries(bindings PRIVATE libFoundation libFoundationInternationalization libFoundationEssentials libswiftDispatch libswiftSynchronization libswiftGlibc lib_FoundationCollections libswift_StringProcessing libswift_RegexParser libdispatch libBlocksRuntime libCoreFoundation lib_FoundationICU lib_FoundationCShims)

target_link_libraries(bindings PRIVATE libswiftCore libstdcxx libswiftSwiftOnoneSupport)

target_link_libraries(bindings PRIVATE pybind11::headers)

install(TARGETS bindings DESTINATION omfilespy)

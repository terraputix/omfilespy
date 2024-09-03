cmake_minimum_required(VERSION 3.15...3.29)

#########
# SWIFT #
#########
# Add a custom target to build the Swift project
add_custom_target(BuildSwiftLib ALL
    COMMAND ${CMAKE_COMMAND} -E chdir ${CMAKE_SOURCE_DIR}/../Swift swift build
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}/../Swift
    COMMENT "Building Swift static library"
)
# Add a custom command to copy the built library to the python directory
add_custom_command(TARGET BuildSwiftLib POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_SOURCE_DIR}/../Swift/.build/debug/libOmFileInterface.a ${CMAKE_SOURCE_DIR}
    COMMENT "Copying libOmFileInterface.a to python directory"
)

##########
# Python #
##########
# Scikit-build-core sets these values for you, or you can just hard-code the
# name and version.
project(
  ${SKBUILD_PROJECT_NAME}
  VERSION ${SKBUILD_PROJECT_VERSION}
  LANGUAGES CXX)

set(PYBIND11_FINDPYTHON ON)
find_package(pybind11 CONFIG REQUIRED)

add_custom_target(BuildOmFiles DEPENDS libOmFileInterface.a)
add_library(OmFilesLib STATIC IMPORTED GLOBAL) # Not sure if GLOBAL is necessary
add_dependencies(OmFilesLib BuildOmFiles)
# IMPORTED_LOCATION needs to be an absolute path, therefore we get this absolute path into the variable LIB_OM_PATH
get_filename_component(LIB_OM_PATH libOmFileInterface.a ABSOLUTE)
set_target_properties(OmFilesLib PROPERTIES IMPORTED_LOCATION ${LIB_OM_PATH})

# Add a library using FindPython's tooling (pybind11 also provides a helper like this)
python_add_library(bindings MODULE bindings.cpp WITH_SOABI)
target_link_libraries(bindings PRIVATE OmFilesLib)
target_link_libraries(bindings PRIVATE pybind11::headers)

install(TARGETS bindings DESTINATION omfilespy)
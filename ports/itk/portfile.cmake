include(vcpkg_common_functions)
set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/ITK-4.11.0)
vcpkg_download_distfile(ARCHIVE
    URLS "https://github.com/InsightSoftwareConsortium/ITK/archive/v4.11.0.zip"
    FILENAME "ITK-4.11.0.zip"
    SHA512 0ca59bfd0197edaabe292897cf3e1b9a9bcfeab85973f6d4139f1bcdc67a487bb2c7c1dcf89161e4c39bfcbceaf26b31aeeb9c84abb636e95ef480becb6ae001
)
vcpkg_extract_source_archive(${ARCHIVE})

if(VCPKG_LIBRARY_LINKAGE STREQUAL dynamic)
    # HACK: The FindHDF5.cmake script does not seem to detect the HDF5_DEFINITIONS correctly
    #       if HDF5 has been built without the tools (which is the case in the HDF5 port),
    #       so we set the BUILT_AS_DYNAMIC_LIB=1 flag here explicitly because we know HDF5
    #       has been build as dynamic library in the current case.
    list(APPEND ADDITIONAL_OPTIONS "-DHDF5_DEFINITIONS=-DH5_BUILT_AS_DYNAMIC_LIB=1")
endif()

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS
        -DBUILD_TESTING=OFF
        -DBUILD_EXAMPLES=OFF
        -DITK_LEGACY_REMOVE=ON
        -DITK_USE_64BITS_IDS=ON
        -DITK_USE_CONCEPT_CHECKING=ON
        # -DITK_WRAP_PYTHON=ON
        # -DITK_PYTHON_VERSION=3
        -DITK_USE_SYSTEM_EXPAT=ON
        -DITK_USE_SYSTEM_FREETYPE=ON
        -DITK_USE_SYSTEM_GLEW=ON
        -DITK_USE_SYSTEM_HDF5=ON
        -DITK_USE_SYSTEM_JSONCPP=ON
        -DITK_USE_SYSTEM_JPEG=ON
        # -DITK_USE_SYSTEM_LIBRARIES=ON
        -DITK_USE_SYSTEM_LIBXML2=ON
        -DITK_USE_SYSTEM_PNG=ON
        -DITK_USE_SYSTEM_TIFF=ON
        -DITK_USE_SYSTEM_SZIP=ON
        -DITK_USE_SYSTEM_ZLIB=ON
        -DITK_INSTALL_DATA_DIR=share/itk/data
        -DITK_INSTALL_DOC_DIR=share/itk/doc
        -DITK_INSTALL_PACKAGE_DIR=share/itk
        -DITK_FORBID_DOWNLOADS=OFF
        -DModule_IOSTL=ON #example how to turn on a non-default module
        -DModule_ITKReview=ON
        -DModule_ITKVtkGlue=OFF # this option requires VTK (to be listed in CONTROL)
                                # VTK is a huge dependency which currently does not build properly
        ${ADDITIONAL_OPTIONS}
    OPTIONS_RELEASE
        -DHDF5_C_LIBRARY=${CURRENT_INSTALLED_DIR}/lib/hdf5.lib
        -DHDF5_C_HL_LIBRARY=${CURRENT_INSTALLED_DIR}/lib/hdf5_hl.lib
    OPTIONS_DEBUG
        -DHDF5_C_LIBRARY=${CURRENT_INSTALLED_DIR}/debug/lib/hdf5_D.lib
        -DHDF5_C_HL_LIBRARY=${CURRENT_INSTALLED_DIR}/debug/lib/hdf5_hl_D.lib
)

vcpkg_install_cmake()
vcpkg_copy_pdbs()

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/share)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)

# Handle copyright
file(COPY ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/itk)
file(RENAME ${CURRENT_PACKAGES_DIR}/share/itk/LICENSE ${CURRENT_PACKAGES_DIR}/share/itk/copyright)

include(vcpkg_common_functions)
set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/ITK-4.12.0)
vcpkg_download_distfile(ARCHIVE
    URLS "https://github.com/InsightSoftwareConsortium/ITK/archive/v4.12.0.zip"
    FILENAME "ITK-4.12.0.zip"
    SHA512 9aa39cdd591c01c9accc73ec953a9c3efd87aa38b53f6ad253bf33a6c52050a7456cda6fd8234c84f76d95e70387125220898bae2f580d1e9bbacd24fc5edbee
)
vcpkg_extract_source_archive(${ARCHIVE})

# directory path length needs to be shorter than 50 characters
file(RENAME ${CURRENT_BUILDTREES_DIR}/src/InsightToolkit-4.12.0 ${SOURCE_PATH})

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS
        -DBUILD_TESTING=OFF
        -DBUILD_EXAMPLES=OFF
        -DITK_INSTALL_DATA_DIR=share/itk/data
        -DITK_INSTALL_DOC_DIR=share/itk/doc
        -DITK_INSTALL_PACKAGE_DIR=share/itk
        -DITK_LEGACY_REMOVE=ON
        -DITK_USE_64BITS_IDS=ON
        -DITK_USE_CONCEPT_CHECKING=ON
        # -DITK_WRAP_PYTHON=ON
        # -DITK_PYTHON_VERSION=3
        # -DITK_USE_SYSTEM_LIBRARIES=ON # enables USE_SYSTEM for many third party libraries which do not have vcpkg ports such as FFTW
        -DITK_USE_SYSTEM_EXPAT=ON
        -DITK_USE_SYSTEM_JPEG=ON
        -DITK_USE_SYSTEM_PNG=ON
        -DITK_USE_SYSTEM_TIFF=ON
        -DITK_USE_SYSTEM_ZLIB=ON
        -DITK_FORBID_DOWNLOADS=OFF
        -DITK_BUILD_DEFAULT_MODULES=OFF # turns on HDF5, which is problematic
        -DITKGroup_IO=OFF # turns on HDF5, which is problematic
        -DModule_ITKReview=OFF # turns on HDF5, which is problematic
        -DITKGroup_Filtering=ON
        -DITKGroup_Registration=ON
        -DITKGroup_Segmentation=ON
        -DModule_ITKIOMesh=ON
        -DModule_ITKIOCSV=ON
        -DModule_IOSTL=ON # example how to turn on a non-default module
        # -DModule_ITKVtkGlue=ON # this option requires VTK to be a dependency in CONTROL file
        -DModule_MorphologicalContourInterpolation=ON # example how to turn on a remote module
        -DModule_RLEImage=ON # example how to turn on a remote module
        ${ADDITIONAL_OPTIONS}
)

vcpkg_install_cmake()
vcpkg_copy_pdbs()

file(REMOVE ${CURRENT_PACKAGES_DIR}/debug/bin/itkTestDriver.exe)
file(REMOVE ${CURRENT_PACKAGES_DIR}/bin/itkTestDriver.exe)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/share)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)

# Handle copyright
file(COPY ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/itk)
file(RENAME ${CURRENT_PACKAGES_DIR}/share/itk/LICENSE ${CURRENT_PACKAGES_DIR}/share/itk/copyright)

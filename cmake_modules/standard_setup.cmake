set(CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake_modules)
set(CMAKE_DISABLE_SOURCE_CHANGES ON)
set(CMAKE_DISABLE_IN_SOURCE_BUILD ON)

set_property(GLOBAL PROPERTY USE_FOLDERS ON)

find_file(MaidSafeExport NAMES maidsafe_export.cmake
                         PATHS ${MAIDSAFE_BINARY_DIR}
                         NO_DEFAULT_PATH)
if(NOT MaidSafeExport)
  set(ErrorMessage "\n\nCan't find maidsafe_export.cmake in MAIDSAFE_BINARY_DIR.  ")
  set(ErrorMessage "${ErrorMessage}Currently MAIDSAFE_BINARY_DIR is set to ")
  set(ErrorMessage "${ErrorMessage}\"${MAIDSAFE_BINARY_DIR}\"  It must be set to the MaidSafe ")
  set(ErrorMessage "${ErrorMessage}super-project's build root.\nTo set it, run:\n")
  set(ErrorMessage "${ErrorMessage}    cmake . -DMAIDSAFE_BINARY_DIR=\"<path to build root>\"\n\n")
  message(FATAL_ERROR "${ErrorMessage}")
endif()
include(${MaidSafeExport})

set(CMAKE_DEBUG_POSTFIX )

if(ANDROID_BUILD)
  if(NOT ANDROID_NDK_ROOT)
    set(ErrorMessage "ANDROID_NDK_ROOT is required for Android builds.\nTo set it, run:\n")
    set(ErrorMessage "${ErrorMessage}    cmake . -DANDROID_NDK_ROOT=\"<path to ndk root>\"\n\n")
    message(FATAL_ERROR "${ErrorMessage}")
  endif()
  set(PLATFORM_PREFIX "${ANDROID_NDK_ROOT}/sysroot")
  set(PLATFORM_FLAGS "-fPIC -Wno-psabi --sysroot=${PLATFORM_PREFIX}")
  set(CMAKE_C_COMPILER "${ANDROID_NDK_ROOT}/bin/arm-linux-androideabi-gcc")
  set(CMAKE_CXX_COMPILER "${ANDROID_NDK_ROOT}/bin/arm-linux-androideabi-g++")
  set(CMAKE_C_FLAGS "${PLATFORM_FLAGS} -march=armv7-a -mfloat-abi=softfp -mfpu=neon" CACHE STRING "")
  set(CMAKE_CXX_FLAGS "${PLATFORM_FLAGS} -march=armv7-a -mfloat-abi=softfp -mfpu=neon" CACHE STRING "")
  set(CMAKE_SHARED_LINKER_FLAGS "-Wl,--fix-cortex-a8" CACHE STRING "")
endif()
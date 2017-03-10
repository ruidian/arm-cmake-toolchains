set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR ARM)

if(MINGW OR CYGWIN OR WIN32)
    set(UTIL_SEARCH_CMD where)
elseif(UNIX OR APPLE)
    set(UTIL_SEARCH_CMD which)
endif()

execute_process(
        COMMAND ${UTIL_SEARCH_CMD} arm-none-eabi-gcc
        OUTPUT_VARIABLE BINUTILS_PATH
        OUTPUT_STRIP_TRAILING_WHITESPACE
)

get_filename_component(ARM_TOOLCHAIN_DIR ${BINUTILS_PATH} DIRECTORY)

set(triple arm-none-eabi)

set(CMAKE_ASM_COMPILER arm-none-eabi-gcc)
set(CMAKE_C_COMPILER clang)
set(CMAKE_C_COMPILER_TARGET ${triple})
set(CMAKE_CXX_COMPILER clang++)
set(CMAKE_CXX_COMPILER_TARGET ${triple})
#set(CMAKE_C_COMPILER_EXTERNAL_TOOLCHAIN ${ARM_TOOLCHAIN_DIR})
#set(CMAKE_CXX_COMPILER_EXTERNAL_TOOLCHAIN ${ARM_TOOLCHAIN_DIR})

set(CMAKE_C_FLAGS " " CACHE STRING "" FORCE)
string(APPEND CMAKE_C_FLAGS "-B ${ARM_TOOLCHAIN_DIR}")
set(CMAKE_C_FLAGS_DEBUG "-g" CACHE STRING "" FORCE)
set(CMAKE_C_FLAGS_RELEASE "-O2 -DNDEBUG" CACHE STRING "" FORCE)
set(CMAKE_C_FLAGS_MINSIZEREL "-Oz -DNDEBUG" CACHE STRING "" FORCE)
set(CMAKE_C_FLAGS_RELWITHDEBINFO "-g -O2" CACHE STRING "" FORCE)
set(CMAKE_CXX_FLAGS " " CACHE STRING "" FORCE)
string(APPEND CMAKE_CXX_FLAGS "-B ${ARM_TOOLCHAIN_DIR}")
set(CMAKE_CXX_FLAGS_DEBUG "-g" CACHE STRING "" FORCE)
set(CMAKE_CXX_FLAGS_RELEASE "-O2 -DNDEBUG" CACHE STRING "" FORCE)
set(CMAKE_CXX_FLAGS_MINSIZEREL "-Oz -DNDEBUG" CACHE STRING "" FORCE)
set(CMAKE_CXX_FLAGS_RELWITHDEBINFO "-g -O2" CACHE STRING "" FORCE)
# provide clang with ARM GCC toolchain include directory info
include_directories(${ARM_TOOLCHAIN_DIR}/../arm-none-eabi/include)

set(CMAKE_EXE_LINKER_FLAGS_INIT "--specs=nosys.specs")
set(CMAKE_OBJCOPY ${ARM_TOOLCHAIN_DIR}/arm-none-eabi-objcopy CACHE INTERNAL "objcopy tool")
set(CMAKE_SIZE_UTIL ${ARM_TOOLCHAIN_DIR}/arm-none-eabi-size CACHE INTERNAL "size tool")

set(CMAKE_FIND_ROOT_PATH ${BINUTILS_PATH})
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)

macro(_generate_object target suffix)
    add_custom_command(TARGET ${target} POST_BUILD
        COMMAND ${CMAKE_OBJCOPY} -Obinary
        "${CMAKE_CURRENT_BINARY_DIR}/${target}${CMAKE_EXECUTABLE_SUFFIX}" "${CMAKE_CURRENT_BINARY_DIR}/${target}${suffix}"
    )
endmacro()

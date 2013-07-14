#DSFML Source Cmake List

# include the SFML specific macros
include(${CMAKE_SOURCE_DIR}/cmake/Macros.cmake)

# let CMake know about our additional libraries paths (on Windows and OS X)
if (WINDOWS)
    set(CMAKE_INCLUDE_PATH ${CMAKE_INCLUDE_PATH} "${PROJECT_SOURCE_DIR}/extlibs/headers")
    if(COMPILER_GCC)
        if(ARCH_32BITS)
				    set(CMAKE_LIBRARY_PATH ${CMAKE_LIBRARY_PATH} "${PROJECT_SOURCE_DIR}/extlibs/libs-mingw/x86")
            set(CMAKE_LIBRARY_PATH ${CMAKE_LIBRARY_PATH} "${PROJECT_SOURCE_DIR}/extlibs/bin/x86")
        elseif(ARCH_64BITS)
				    set(CMAKE_LIBRARY_PATH ${CMAKE_LIBRARY_PATH} "${PROJECT_SOURCE_DIR}/extlibs/libs-mingw/x64")
            set(CMAKE_LIBRARY_PATH ${CMAKE_LIBRARY_PATH} "${PROJECT_SOURCE_DIR}/extlibs/bin/x64")
        endif()
    elseif(COMPILER_MSVC)
        if(ARCH_32BITS)
            set(CMAKE_LIBRARY_PATH ${CMAKE_LIBRARY_PATH} "${PROJECT_SOURCE_DIR}/extlibs/libs-msvc/x86")
        elseif(ARCH_64BITS)
            set(CMAKE_LIBRARY_PATH ${CMAKE_LIBRARY_PATH} "${PROJECT_SOURCE_DIR}/extlibs/libs-msvc/x64")
        endif()
    endif()
elseif(MACOSX)
    set(CMAKE_INCLUDE_PATH ${CMAKE_INCLUDE_PATH} "${PROJECT_SOURCE_DIR}/extlibs/headers")
    set(CMAKE_LIBRARY_PATH ${CMAKE_LIBRARY_PATH} "${PROJECT_SOURCE_DIR}/extlibs/libs-osx/lib/")
endif()

# add the CSFML sources path
include_directories(${CMAKE_SOURCE_DIR}/src)

# define the path of our additional CMake modules
set(CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake/Modules/")

# set the output directory for CSFML libraries
set(LIBRARY_OUTPUT_PATH "${CMAKE_BINARY_DIR}/lib")

# define the export symbol
add_definitions(-DCSFML_EXPORTS)

# disable stupid warnings with Visual C++
if(COMPILER_MSVC)
    add_definitions(-D_CRT_SECURE_NO_WARNINGS)
endif()

# find SFML libraries (C++)
if(WINDOWS)
    set(SFML_STATIC_LIBRARIES TRUE)
    add_definitions(-DSFML_STATIC)
endif()

find_package(SFML 2.0 COMPONENTS system network audio REQUIRED)
#When completed, the line above should look like as follows
#find_package(SFML 2.0 COMPONENTS system window network graphics audio REQUIRED)



#find_package(SFML 2.0 COMPONENTS system window network graphics audio REQUIRED)
include_directories(${SFML_INCLUDE_DIR})

# add the modules subdirectories
add_subdirectory(System)
#add_subdirectory(Window)
add_subdirectory(Network)
#add_subdirectory(Graphics)
add_subdirectory(Audio)


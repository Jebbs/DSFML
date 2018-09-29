cmake_minimum_required (VERSION 2.8.3)

project (DSFMLC)

option(STATIC_SFML "Build DSFMLC expecting static SFML libs" ON)

set(CMAKE_BUILD_TYPE Release)

#we want to make sure we're linking to static crt libs
#Stolen from stack overflow
if(MSVC)
# We statically link to reduce dependencies
foreach(flag_var CMAKE_CXX_FLAGS CMAKE_CXX_FLAGS_DEBUG CMAKE_CXX_FLAGS_RELEASE CMAKE_CXX_FLAGS_MINSIZEREL CMAKE_CXX_FLAGS_RELWITHDEBINFO)
    if(${flag_var} MATCHES "/MD")
        string(REGEX REPLACE "/MD" "/MT" ${flag_var} "${${flag_var}}")
    endif(${flag_var} MATCHES "/MD")
    if(${flag_var} MATCHES "/MDd")
        string(REGEX REPLACE "/MDd" "/MTd" ${flag_var} "${${flag_var}}")
    endif(${flag_var} MATCHES "/MDd")
endforeach(flag_var)
endif(MSVC)


#DSFML should work for all patch versions
set(VERSION_MAJOR 2)
set(VERSION_MINOR 4)


#add DSFMLC and SFML header paths
include_directories(${CMAKE_CURRENT_SOURCE_DIR}/../../SFML/include)
include_directories(${CMAKE_CURRENT_SOURCE_DIR}/../)


add_subdirectory(System)
add_subdirectory(Audio)
add_subdirectory(Network)
add_subdirectory(Window)
add_subdirectory(Graphics)

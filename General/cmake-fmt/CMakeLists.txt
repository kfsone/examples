cmake_minimum_required(VERSION 3.20)

include(cmake/CPM.cmake)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

### This causes a duplicate instantiation error
# add_compile_definitions(FMT_HEADER_ONLY=1)

project(TestProj CXX)

CPMAddPackage(
	NAME fmt
	GIT_TAG master
	GITHUB_REPOSITORY fmtlib/fmt
)
include_directories("${fmt_SOURCE_DIR}/include")

add_subdirectory(src)


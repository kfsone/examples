add_executable(main "main.cpp")
#target_compile_definitions(main
#	PUBLIC
#	FMT_HEADER_ONLY=1
#)
target_link_libraries(main
	PRIVATE
	fmt::fmt-header-only
)

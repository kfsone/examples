This example demonstrates the potential duplicity of pointer-to-member-functions
but it also demonstrates the lack of any reporting of this by the MSVC compiler
or IDE.

- Build as-is with Visual Studio,
- Step into the debugger,
- Step into printPmfs,
- Mouse-over mPmf1 and mPmf2, note values,
- Step over the printf,
- Observe the console window printed different values than the debugger showed,
- Comment out the annotated line in pmf.cpp and repeat debug,
- Observe the values are different-different,
- Repeat alternation a few times to see the behavior is *consistent*,
- Also note the differents in size reporting.

Other ways you can cause similar problems:

	- pragma pack(push) include pragma pack(pop) in one header
	- name collisions, e.g from macros


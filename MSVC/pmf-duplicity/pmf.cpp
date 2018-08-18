//NOTE: Compile & debug once, stepping into printPmfs. Inspect both mPmf pointers.
//NOTE: Then rebuild with the first "#include mpmfs2.h" commented out and repeat.

#include "pmfs1.h"
#include "pmfs2.h"	//NOTE: Comment out for second debug run.
#include "pmf.h"
#include "pmfs2.h"

int main()
{
	T t;
	t.setPmfs(&S1::memberFn, &S2::memberFn);
	t.printPmfs();
}

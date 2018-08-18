// In this TU, only S1 is defined before forming a PMF type in pmf.h
#include "pmfs1.h"
#include "pmf.h"
#include "pmfs2.h"

#include <stdio.h>

void T::printPmfs() const
{
	// Using printf for it's function-call appearance.
	printf("mPmf1 = %p, mPmf2 = %p\n", mPmf1, mPmf2);

	//HERE: Inspect mPmf1 and mPmf2. Then rebuild without including pmfs2.h in pmf.cpp
}

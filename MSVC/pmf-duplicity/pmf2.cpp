// In this TU, both S1 and S2 are defined before pmf.h
#include "pmfs1.h"
#include "pmfs2.h"
#include "pmf.h"

#include <stdio.h>

void T::setPmfs(PMF1 value1, PMF2 value2)
{
	mPmf1 = value1;
	mPmf2 = value2;

	// using printf for it's function like appearance.
	printf("%p=>mPmf1, %p=>mPmf2\n", mPmf1, mPmf2);
}

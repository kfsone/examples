#pragma once

// Forward declare structures, but only S1 is #included first in both TU.
struct S1;
struct S2;

// Create type aliases for PMFs to each class
using PMF1 = void(S1::*)();
using PMF2 = void(S2::*)();

// Try defining this and compiling both TUs. One works, one doesn't.
// Now bear in mind that when you don't define it, they compile and link...
//
#if defined(JUST_STATIC_ASSERT)
static_assert(sizeof(PMF1) == sizeof(PMF2), "Sizes mismatch");
#endif

// The padding isn't strictly required for the MVCE, but it will make
// clearer during debugging what you are looking at vs what you are being
// told you are looking at.
//
struct T
{
	unsigned long long mPad1 { 0x0101010101010101ULL };

	PMF1	mPmf1 { nullptr };
	PMF2	mPmf2 { nullptr };

	unsigned long long mPad2 { 0x1010101010101010ULL };
	unsigned long long mPad3 { 0x0202020202020202ULL };
	unsigned long long mPad4 { 0x2020202020202020ULL };
	unsigned long long mPad5 { 0x0303030303030303ULL };
	unsigned long long mPad6 { 0x3030303030303030ULL };

	// Each of thes functions is implemented in a different TU.
	void setPmfs(PMF1 value1, PMF2 value2);
	void printPmfs() const;
};


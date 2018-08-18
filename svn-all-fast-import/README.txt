Running under Ubuntu 18.04, this simple test crashes early on and fails to
perform conversion because fast_import crashes and the converter app
doesn't appear to notice.

Usage:

    ./repro.sh

This will create an 'r' (for repro) folder with an svn-src and svn.wc folder,
it will add revisions to the svn repos thru the working copy and then attempt
to run a series of imports (it increments the max revision one step at a time)

The original repository being converted has a top-level "/repos" path prefix,
so the urls are https://server/svn/repos/..., and my hunch was that the
elimination of that prefix path was causing the crash.

Given this crashes out fairly soon that assumption seems correct.


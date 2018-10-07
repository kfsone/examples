#! /bin/bash

TOP_DIR=$(realpath $(dirname $0))
R_DIR="${TOP_DIR}/r"
SVN_FOLDER="svn-src"
SVN_DIR="${R_DIR}/${SVN_FOLDER}"
GIT_PREFIX="git-r"

die () {
  echo "ERROR: $@"
  exit 1
}

echo "-- Working in: ${TOP_DIR} -> ${R_DIR}"

# Sanity check the workspace
[ -d "${TOP_DIR}" -a -f "${TOP_DIR}/$(basename $0)" ] || die "Can't find working folder"
cd "${TOP_DIR}" || die "Can't access working folder"
[ -f "repro.sh" ] || die "'repro.sh' not in working folder"

REVISIONS=0
commit () {
  REVISIONS=$((REVISIONS + 1))
  svn commit --username john.doe -m "$@"
}

# Folder for repositories
rm -rf "${R_DIR}"
mkdir "${R_DIR}" || die "Couldn't create ${R_DIR}"

# Create the svn repository
pushd "${R_DIR}"
{
  echo "-- SVN Admin create ${SVN_FOLDER}"
  svnadmin create ${SVN_FOLDER} || die "svnadmin create failed"

  svn co file://${SVN_DIR} svn.wc || die "Couldn't create working copy"

  echo "-- Populating SVN repository with commits"
  pushd "svn.wc"
  {
    # First git repository equivalent
    # Revision 1 content, two folders, a file.
    mkdir -p r1/repos/Source r1/repos/Docs || die "Failed to create test folder"
    :> r1/repos/Source/test1.txt
    svn add r1 >/dev/null
    commit "First rev" || die "Commit failed"

    # Revision 2, a change
    echo "R2 added content" >r1/repos/Source/test1.txt
    commit "Second rev" || die "Commit failed"

    # Rev 3 adding a file
    echo "R3 added file/content" >r1/repos/Source/test2.txt
    commit "Third rev" || die "Commit failed"

    # Rev 4 create a branches folder at the top level
    mkdir -p r1/Branches || die "Failed to create test folder"
    svn add r1/Branches >/dev/null
    commit "Fourth rev" || die "Commit failed"

    # R5 Copy r1/repos/* to Branches
    svn cp r1/repos r1/Branches/first >/dev/null
    commit "Fifth rev" || die "Commit failed"

    #### Next repository variant
    mkdir -p r2/Source || die "Failed to create test folder"
    :>r2/Source/test3.txt
    svn add r2 >/dev/null
    commit "Sixth rev" || die "Commit failed"

    # Modify
    echo "modification" >r2/Source/test3.txt
    commit "Seven" || die "Commit failed"

    # Create an in-line branch, because: derp
    svn cp r2/Source r2/Live
    commit "r2 source -> live" || die "Commit failed"

    # Modify the test3.txt in r2/Source
    echo "master" >>r2/Source/test3.txt
    commit "modify r2's master test3.txt" || die "Commit failed"

    # Modify the test3.txt in the r2/branch
    echo "branch" >>r2/Live/test3.txt
    commit "modify r2's live test3.txt" || die "Commit failed"
  }
  popd
}
popd

echo "-- Produced ${REVISIONS} revisions"
sleep 1

# Execute the conversion incrementing max rev one at a time
step=1
while [ ${step} -lt ${REVISIONS} ]; do
  echo "---------------------------------------------------------------------"
  echo "-- Attempting to export --max-rev=$step"
  pushd "${R_DIR}"
  {
    rm -rf ./${GIT_PREFIX}*

    svn-all-fast-export \
      --identity-map "${TOP_DIR}/authors.txt" \
      --identity-domain unknown.unk \
      --rules "${TOP_DIR}/repro.rules" \
      --add-metadata \
      --stats \
      --empty-dirs \
      --propcheck \
      --svn-ignore \
      --svn-branches \
      --max-rev ${step} \
      "${SVN_DIR}" \
        || die "Attempt ${step} failed"
  }

  # Test if there are any fast_import crashes
  if compgen -G git-r*/fast_import_crash_*; then
    die "Step $step: Fast import crashed"
  fi

  step=$((step + 1))
  echo
  popd
done


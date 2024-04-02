# About this repository

This repository is a stripped-down version of the _BioCro_ repository,
located at https://github.com/biocro/biocro, together with its
`framework` submodule, located at https://github.com/biocro/framework.
It contains the bulk of the C++ code located in the BioCro
repository's `src` and `inc` subdirectories, but it leaves out most of
the R-related files.  It also leaves out the `Makevars` and
`Makevars.win` files; instead, it contains a CMake list file for
building the BioCro C++ library using CMake.

It is intended that this repository provide an easy way to obtain and
build the BioCro C++ library without having to use R and without
having to download the complete BioCro R source package.

## Updating this repository to track changes made to the BioCro GitHub repository

Here we outline a procedure for updating this repository to
incorporate the latest changes from the BioCro repository.  There are
two main steps: updating the C++ code and updating the version
information.

### Initial steps

* Check out the latest version of the _master_ branch of this
repository, or pull the latest changes if already checked out.

* Be sure the working copy is a clean copy with no uncommitted
changes or untracked files.  You can check that the copy is clean by
running

        git status

    in one of the working-copy directories.  If this shows changes you
    want keep, you can stash the untracked files and any changes to
    tracked files by running

        git stash -u

    Otherwise, you can run

        git clean -fd

    in the top-level working-copy directory to remove any untracked
    files, and

        git reset --hard

    in any working-copy directory to remove any uncommitted changes to
    tracked files.  The working copy will now be in a clean state.

* *Recommended:* Make and switch to a branch of this repository for
the purpose of incorporating the latest changes.  Call the branch
something like `vX.Y.Z-updates`, where `X.Y.Z` is the version number
of the BioCro R package release upon which you are basing the updated
version of this repository.  Usually, this will be the version
corresponding to the latest BioCro release.

* Clone the BioCro repository with

        git clone --recurse-submodules git@github.com:biocro/biocro.git

To make the exposition in what follows simpler, we will assume that
the BioCro repository and _this_ repository are checked out into
sibling directories having the same parent directory.  We also assume
the default branch just checked out corresponds to the BioCro release
upon which one wants to base the updated version of `biocro-lib`.

### Steps for updating the C++ code

* Switch into the `biocro-lib` top-level directory.

* Run rsync to copy changed files from the BioCro repository using

        rsync -aiv --exclude-from=biocro_files_to_ignore --delete ../biocro/src .

    This will copy any new files from the BioCro repository's `src`
    directory and update existing files except those listed in the
    `biocro_files_to_ignore` exclusion list.  It will also remove any
    files in the current repository's `src` directory that are no
    longer in the BioCro repository's `src` directory.

* Repeat this procedure with the `inc` directory, which contains the
Boost library code (the `--exclude-from` option is not needed here):

        rsync -aiv --delete ../biocro/inc .

### Updates to `biocro_files_to_ignore`

In the rare case that a file is added under the BioCro R project `src`
directory that _shouldn't_ be added to this repository, it may be
necessary to make addtions to the `biocro_files_to_ignore` file used
in the rsync command above.

Similarly, if a file listed in `biocro_files_to_ignore` is removed
from the BioCro repository, that file name may also be removed from
`biocro_files_to_ignore`.

### Updates for CMake

* If any C++ source files were added or deleted, adjust the set of
files designated by a `target_sources` command in the CMake list file
as source files for the `BioCro` target.

* Update the version number in the `project()` command.

### Final steps

* Stage the changes made to existing files for commit using

        git add -u

    (This command also takes care of staging the removal from the
    repository of any files that were deleted because they are no
    longer in the BioCro repository.)  If there are new files, `git
    add` them.

* Review the staged changes by running

        git status

    If adjustments to the index are required, an easy way to do this
    is by running `git add` interactively:

        git add -i

* Once the correct set of files has been staged, commit them with

        git commit

    The commit message should mention the release version of the
    BioCro repository being emulated (and possibly the commit hash as
    well).

* Switch to the master branch of this repository and merge in the
branch changes.

* Tag the new HEAD of the master branch with a new release number.
  For example, for a version number of 3.0.2, use the tag "v3.0.2".
  This should match the version number used in `CMakeLists.txt`'s
  `project` command.

## Using `biocro-lib` in other projects

We talk here specifically about the DAWN project
(https://github.com/gsrohde/DAWN), as this was the original motivation
for creation of this repository.

* Once `biocro-lib` has been updated, a project that uses this
repository as a submodule may be updated to point to the new version.
(This new master-branch version doesn't get used automatically by the
parent respository.)

* In the DAWN project in particular, changes to the BioCro code may
  affect simulation results.  Therefore, it is possible that the
  regression tests DAWN uses will have to be updated.



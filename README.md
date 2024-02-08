# About this repository

This repository is a stripped-down version of the _BioCro_ repository
located at https://github.com/biocro/biocro together with its
`framework` submodule, located at https://github.com/biocro/framework.
It contains the bulk of the C++ code located in the BioCro
repository's `src` and `inc` subdirectories but it leaves out most of
the R-related files.  It also leaves out the `Makevars` and
`Makevars.win` files; instead, it contains a CMake list file for
building the BioCro C++ library using CMake.

It is intended that this repository provide an easy way to obtain and
build the BioCro C++ library without having to use R and without
having to download the complete BioCro R source package.

## Updating this repository to track changes made to
   https://github.com/biocro/biocro.

Here we outline a procedure for updating this repository with the
latest changes from the BioCro repository.

1. Check out the latest version of this repository or pull the latest
changes if already checked out.

2. Be sure the working copy is a clean copy with no uncommitted
changes or untracked files.  You can check that the copy is clean by
running

    git clean -nd

in the top-level directory.  If this shows no changes you want keep,
you can run

    git clean -fd

to set the working copy to a clean state.  Otherwise, you can stash
the changes and the untracked files with

    git stash -u

3. Recommended: Make and switch to a branch of this repository for the
purpose of incorporating the latest changes.

4. Clone the BioCro repository with

    git clone --recurse-submodules git@github.com:biocro/biocro.git

To make the exposition simpler, we will assume in what follows that
the BioCro repository and this repository are checked out into sibling
directories having the same parent directory.  We also assume the
default branch just checked out is the corresponds to the BioCro
release upon which we want to base the updated version of
`biocro-lib`.

5. Switch into the `biocro-lib` top-level directory.

6. Run rsync to copy changed files from the BioCro repository using

    rsync -aiv --exclude-from=biocro_files_to_ignore --delete ../biocro/src .

This will copy any new files from the BioCro repository's `src`
directory and update existing files except those listed in the
`biocro_files_to_ignore` exclusion list.  It will also remove any
files in the current repository's `src` directory that are no longer
in the BioCro repository's `src` directory.

7. Repeat this procedure with the `inc` directory, which contains the
Boost library code (the --exclude-from option is not needed here):

    rsync -aiv --delete ../biocro/inc .

8. Stage the changes made to existing files for commit using

    git add -u

If there are new files, `git add` them.

9. If any C++ source files were added or deleted, adjust the set of
files designated by a `target_sources` command in the CMake list file
as source files for the `BioCro` target; then `git add` the revised
`CMakeLists.txt` file.

10. Review the staged changes by running

    git status

If adjustments to the index are required, an easy way to do this is by
running `git add` interactively:

    git add -i

11. Once the correct set of files have been staged, commit them with

    git commit

The commit message should mention the release version of the BioCro
repository being emulated (and possibly the commit hash as well).

12. Switch to the master branch of this repository and merge in the
branch changes.

13. Tag the new HEAD of the master branch with a new release number.




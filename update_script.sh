#!/usr/bin/env bash

tracking_branch=biocro-tracking-branch # to track BioCro
master_branch=master
read -d '' r_only_files<<EOF
.Rbuildignore
.clang-format
.editorconfig
.gitattributes
.github
.gitignore
DESCRIPTION
LICENSE.md
LICENSE.note
NAMESPACE
NEWS.md
R
README.md
bookdown
cran-comments.md
data
developer_documentation
documentation
doxygen
man
pkgdown
src/Makevars
src/Makevars.win
src/R_dynamical_system.cpp
src/R_dynamical_system.h
src/R_get_all_ode_solvers.cpp
src/R_get_all_ode_solvers.h
src/R_get_all_se_solvers.cpp
src/R_get_all_se_solvers.h
src/R_module_library.cpp
src/R_module_library.h
src/R_modules.cpp
src/R_modules.h
src/R_run_biocro.cpp
src/R_run_biocro.h
src/R_simultaneous_equations.cpp
src/R_simultaneous_equations.h
src/R_system_derivatives.cpp
src/R_system_derivatives.h
src/framework/R_helper_functions.cpp
src/framework/R_helper_functions.h
src/framework_ed
src/init.cpp
tests
vignettes
EOF

#set -e # Exit immediately if command has non-zero exit status,  (Applies to simple commands only.)

git diff-index --quiet HEAD || {
    >&2 echo "Changes detected in working directory.  Commit, stash, or discard them before running this script."
    exit 1
}


read -p "about to check out $tracking_branch ... [press ENTER to continue]"

if git show-ref --quiet --verify -- "refs/heads/$tracking_branch"; then
    git checkout --quiet $tracking_branch
else
    >&2 echo "Tracking branch $tracking_branch doesn't exist; quitting."
    exit 1
fi

echo -e "done\n"


read -p "about to get and store the SHA-1 hash for $tracking_branch ... [press ENTER to continue]"
tracking_branch_hash=`git show-ref --hash --verify -- "refs/heads/$tracking_branch"`
echo -e "done\n"

echo "about to create or reset tmp branch if needed"

if git show-ref --quiet --verify -- "refs/heads/tmp"; then
    # This script assumes that if tmp DOES exist, then it must point to the same commit as $tracking_branch.
    if [ `git show-ref --hash --verify -- "refs/heads/tmp"` != $tracking_branch_hash ]; then
        >&2 echo "Branch tmp doesn't point to the same commit as branch $tracking_branch."
        >&2 echo "You can fix this by running 'git checkout tmp; git reset --hard $tracking_branch'."
        >&2 echo "Exiting."
        exit 1;
    else
        echo "tmp already set appropriately"
    fi
else
    read -p "creating tmp ... [press ENTER to continue]"
    git branch tmp
    echo -e "done\n"
fi


read -p "about to check out tmp branch ... [press ENTER to continue]"
git checkout tmp
echo -e "done\n"


read -p "about to rebase tmp on top of $master_branch ... [press ENTER to continue]"

git rebase $master_branch

if [ $? == 0 ]; then
    echo "Rebase successful!"
else
    >&2 echo "Problems with rebase!!!"
    >&2 echo "Restore previous state with 'git rebase --abort'."
    >&2 echo "Exiting"
    exit 1
fi

echo -e "done\n"


read -p "about to remove any R-only files we committed ... [press ENTER to continue]"

for file in $r_only_files; do
    git rm -r $file
done

echo -e "done\n"


read -p "about to amend the last commit to not include the R-only files ... [press ENTER to continue]"
git commit --amend -m "This commit shouldn't be retained!"
echo -e "done\n"

prompt="about to reset tmp to $master_branch, keeping all changes from\n"
prompt+="the rebase in the index, so we can squash the rebase\n"
prompt+="down to one commit ... [press ENTER to continue]"
echo -n -e $prompt
read
git reset --soft $master_branch
echo -e "done\n"

read -p "about to commit the rebase changes as one commit ... [press ENTER to continue]"
git commit -m "Brought in changes from $tracking_branch up to commit $tracking_branch_hash."
echo -e "done\n"

read -p "about to check out $master_branch ... [press ENTER to continue]"
git co $master_branch
echo -e "done\n"

read -p "about to merge in changes from the tmp branch (should be fast forward) ... [press ENTER to continue]"
git merge tmp
echo -e "done\n"

read -p "about to delete the tmp branch ... [press ENTER to continue]"
git branch -d tmp
echo -e "done\n"

################################################################################
################################### Summary ####################################

##  tracking_branch=biocro-tracking-branch # to track BioCro
##  master_branch=master
##  read -d '' r_only_files<<EOF
##  .Rbuildignore
##  .clang-format
##  .editorconfig
##  .gitattributes
##  .github
##  .gitignore
##  DESCRIPTION
##  LICENSE.md
##  LICENSE.note
##  NAMESPACE
##  NEWS.md
##  R
##  README.md
##  bookdown
##  cran-comments.md
##  data
##  developer_documentation
##  documentation
##  doxygen
##  man
##  pkgdown
##  src/Makevars
##  src/Makevars.win
##  src/R_dynamical_system.cpp
##  src/R_dynamical_system.h
##  src/R_get_all_ode_solvers.cpp
##  src/R_get_all_ode_solvers.h
##  src/R_get_all_se_solvers.cpp
##  src/R_get_all_se_solvers.h
##  src/R_module_library.cpp
##  src/R_module_library.h
##  src/R_modules.cpp
##  src/R_modules.h
##  src/R_run_biocro.cpp
##  src/R_run_biocro.h
##  src/R_simultaneous_equations.cpp
##  src/R_simultaneous_equations.h
##  src/R_system_derivatives.cpp
##  src/R_system_derivatives.h
##  src/framework/R_helper_functions.cpp
##  src/framework/R_helper_functions.h
##  src/framework_ed
##  src/init.cpp
##  tests
##  vignettes
##  EOF
##  #set -e # Exit immediately if command has non-zero exit status,  (Applies to simple commands only.)
##  git diff-index --quiet HEAD || {
##      >&2 echo "Changes detected in working directory.  Commit, stash, or discard them before running this script."
##      exit 1
##  }
##  if git show-ref --quiet --verify -- "refs/heads/$tracking_branch"; then
##      git checkout --quiet $tracking_branch
##  else
##      >&2 echo "Tracking branch $tracking_branch doesn't exist; quitting."
##      exit 1
##  fi
##  tracking_branch_hash=`git show-ref --hash --verify -- "refs/heads/$tracking_branch"`
##  if git show-ref --quiet --verify -- "refs/heads/tmp"; then
##      # This script assumes that if tmp DOES exist, then it must point to the same commit as $tracking_branch.
##      if [ `git show-ref --hash --verify -- "refs/heads/tmp"` != $tracking_branch_hash ]; then
##          >&2 echo "Branch tmp doesn't point to the same commit as branch $tracking_branch."
##          >&2 echo "You can fix this by running 'git checkout tmp; git reset --hard $tracking_branch'."
##          >&2 echo "Exiting."
##          exit 1;
##      else
##          echo "tmp already set appropriately"
##      fi
##  else
##      git branch tmp
##  fi
##  git checkout tmp
##  git rebase $master_branch
##  if [ $? == 0 ]; then
##      echo "Rebase successful!"
##  else
##      >&2 echo "Problems with rebase!!!"
##      >&2 echo "Restore previous state with 'git rebase --abort'."
##      >&2 echo "Exiting"
##      exit 1
##  fi
##  for file in $r_only_files; do
##      git rm -r $file
##  done
##  git commit --amend -m "This commit shouldn't be retained!"
##  git reset --soft $master_branch
##  git commit -m "Brought in changes from $tracking_branch up to commit $tracking_branch_hash."
##  git co $master_branch
##  git merge tmp
##  git branch -d tmp

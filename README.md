# OMSimulator-3rdParty

OpenModelica FMI &amp; TLM simulator - third party sources used by OMSimulator

## FMIL (FMILibrary)

- https://svn.jmodelica.org/FMILibrary/trunk/ [revision 9639]

## Lua

- https://www.lua.org/download.html [version 5.3.4]

## PugiXML

- http://pugixml.org/ [https://github.com/zeux/pugixml]

## CVODE

- https://computation.llnl.gov/projects/sundials/sundials-software [version 2.9.0]

## KINSOL

- https://computation.llnl.gov/projects/sundials/sundials-software [version 2.9.0]

## Ceres Solver

- https://github.com/ceres-solver/ceres-solver [sha 2b5a1e0d6eab7d73924e7f6829c53f4ff834ee34]

  Inserted as git subtree by
  ```bash
  git subtree add --prefix ceres-solver https://github.com/ceres-solver/ceres-solver.git master --squash
  ```
  Update to latest version by replacing `add` by `pull`. Replace `master` by something like `tags/1.12.0`
  to get a specific revision (see https://developer.atlassian.com/blog/2015/05/the-power-of-git-subtree/).

## Eigen

- https://github.com/eigenteam/eigen-git-mirror [version 3.3.4]

  Inserted as git subtree by

  ```bash
  git subtree add --prefix eigen https://github.com/eigenteam/eigen-git-mirror.git tags/3.3.4 --squash
  ```
## gflags

- https://github.com/gflags/gflags.git [version 2.2.1]

  Inserted as git subtree by

  ```bash
  git subtree add --prefix gflags https://github.com/gflags/gflags.git tags/v2.2.1 --squash
  ```

## glog

- https://github.com/google/glog.git [version 2.2.1]

  Inserted as git subtree by

  ```bash
  git subtree add --prefix glog https://github.com/google/glog.git tags/v0.3.5 --squash
  ```

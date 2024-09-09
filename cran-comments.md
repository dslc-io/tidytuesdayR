## Release summary

* Refactor to use 'gh' package for all github activity.
* Mock all tests so that tests work offline.
* Only run examples in interactive sessions.
* Changed maintainer to jonthegeek@gmail.com and moved repository to the dslc-io organization.
* There are no reverse dependencies to check at this time

## Test environments

* local R installation, R 4.4.1
* ubuntu 22.04 (on github actions), R-release, R-devel, R-oldrel-1
* mac OS (on github actions) R-release
* Windows-latest (on github actions) R-release
* win-builder (devel)

## R CMD check results

Dealt with internet usage issues, and changed maintainer of package.

0 errors | 0 warnings | 1 note

  Maintainer: 'Jon Harmon <jonthegeek@gmail.com>'
  
  New submission
  
  Package was archived on CRAN
  
  CRAN repository db overrides:
    X-CRAN-Comment: Archived on 2024-08-31 for policy violation.
  
    On Internet access.

## Resubmission

This is a resubmission. In this version I have:

* Added return values for last_tuesday() and use_tidytemplate().
* Removed examples from tt_date() and formally flagged it as internal.

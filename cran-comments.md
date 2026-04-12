## R CMD check results

0 errors | 0 warnings | 0 notes

## Previous check failures

> Flavor: r-devel-linux-x86_64-debian-gcc
> Check: tests, Result: NOTE
>     Running 'testthat.R' [29s/10s]
>   Running R code in 'testthat.R' had CPU time 2.9 times elapsed time

We now avoid tests that involve project creation & file saving on environments that might have issues with those checks.

We now also set OMP_THREAD_LIMIT envvar to 2.

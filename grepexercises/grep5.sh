#!/bin/sh
#Print all lines that do not begin with a capital S.
grep -E '^[^S].*' grepdata.txt

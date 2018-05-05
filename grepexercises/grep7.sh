#!/bin/sh
#Print all lines that contain an email address (they have an @ in them), preceded by the line number.
egrep -n '@' grepdata.txt
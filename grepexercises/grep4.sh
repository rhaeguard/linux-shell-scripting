#!/bin/sh
#Print all lines containing a vowel (a, e, i, o, or u) followed by a single character followed by the same vowel again. Thus, it will find “eve” or “adam” but not “vera”. Hint: \( and \)
grep -E '([aeoui])[a-z]\1' grepdata.txt

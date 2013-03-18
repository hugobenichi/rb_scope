#!/bin/bash
#
# This script takes into input the path to the ivi and niScope headers
# on the local machine, and use them to generate a text file of pairs
# name / values.
#
# This script is meant to be used in a Unix environment
# (for example cygwin on windows)

path_to_headers=$1

ext/rb_scope/generators/extract_names.rb $path_to_headers/niScope.h   >  ni_scope_names.h
ext/rb_scope/generators/extract_names.rb $path_to_headers/ivi.h       >> ni_scope_names.h
ext/rb_scope/generators/extract_names.rb $path_to_headers/IviScope.h  >> ni_scope_names.h

#gcc -E ni_scope_names.h -I$path_to_headers > ni_scope_preprocessed
#ext/rb_scope/generators/extract_pairs.rb ni_scope_preprocessed > lib/rb_scope/api/niScope_pairs

gcc -E ni_scope_names.h -I$path_to_headers > ni_scope_preprocessed
ext/rb_scope/generators/extract_pairs.rb ni_scope_preprocessed > lib/rb_scope/api/niScope_pairs

rm ni_scope_names.h ni_scope_preprocessed


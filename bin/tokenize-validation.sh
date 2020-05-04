#!/usr/bin/env bash
# Copyright (c) 2018-present, Facebook, Inc.
# All rights reserved.
#
# This source code is licensed under the license found in the
# LICENSE file in the root directory of this source tree.
#

set -e

INPUT_FROM_SGM=/mosesdecoder/scripts/ems/support/input-from-sgm.perl
REM_NON_PRINT_CHAR=/mosesdecoder/scripts/tokenizer/remove-non-printing-char.perl
TOKENIZER=/mosesdecoder/scripts/tokenizer/tokenizer.perl
NORM_PUNC=/mosesdecoder/scripts/tokenizer/normalize-punctuation.perl

while getopts 'i:l:p:o:' opt; do
    case $opt in
        i) INPUT=$OPTARG ;;
        l) LANG=$OPTARG ;;
        p) THREADS=$OPTARG ;;
        o) OUTPUT=$OPTARG ;;
    esac
done

# tokenize data
echo "Tokenizing valid and test data $LANG..."

cat $INPUT | $NORM_PUNC -l $LANG | $TOKENIZER -l $LANG -no-escape -threads $THREADS > $OUTPUT

$INPUT_FROM_SGM < $INPUT | $NORM_PUNC -l $LANG | $REM_NON_PRINT_CHAR | $TOKENIZER -l $LANG -no-escape -threads $THREADS > $OUTPUT

echo "$LANG monolingual data tokenized and validated in: $OUTPUT"
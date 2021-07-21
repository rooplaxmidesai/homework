#!/usr/bin/env python 
import sys
from nltk.tokenize import word_tokenize

#stdin = standard input
for line in sys.stdin: 
    
    #strip white spaces at beginning and end of line
    line = line.strip()

    #tokenize each line into words
    words =  word_tokenize(line)
    for word in words:
        #Taking words that are alphabets and make it lower case
        if word.isalpha():
            print(word.lower() + "\t1")


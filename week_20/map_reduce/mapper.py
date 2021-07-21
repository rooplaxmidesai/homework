#!/usr/bin/env python 
import sys
from nltk.tokenize import word_tokenize

#stdin = standard input
for line in sys.stdin: 
    
    #strip white spaces at beginning and end of line
    line = line.strip()

    #split each line into words
    #words = line.split()
    words =  word_tokenize(line)
    for word in words:
        print(word + "\t1")


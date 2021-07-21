#!/usr/bin/env python 
import sys
from nltk.tokenize import word_tokenize
import pandas as pd
from collections import Counter
#import codecs

n = len(sys.argv)
if n==2:
    filename = sys.argv[1]
    # Using readlines()
    #['cp1252', 'cp850','utf-8','utf8','utf-16','iso-8859-15','cp437']
    #to resolve decoding error tried different encoding types.  encoding='iso-8859-15' worked!
    with open(filename,'r',encoding='iso-8859-15') as file1:   
        #file1 =  codecs.open(filename, 'r', encoding='iso-8859-15') 
        lines = file1.readlines()
        words_count = []
        #stdin = standard input
        for line in lines: 
            
            #strip white spaces at beginning and end of line
            line = line.strip()
        
            #split each line into words
            words =  word_tokenize(line)
            for word in words:
                words_count.append(word)
            
    #print(pd.Series(words).value_counts())
    word_cnt = Counter(words_count)
    print(word_cnt)
else:
    print("Pass filename as commandline argument")
   

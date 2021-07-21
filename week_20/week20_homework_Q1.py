#!/usr/bin/env python 
import sys
from nltk.tokenize import word_tokenize
import pandas as pd
from collections import Counter
#import codecs

#Get the number of command line arguments
n = len(sys.argv)

#If the command line arguments are 2
# python week20_homework_Q1.py cats_txt.txt , here first command line argument is .py file 
# and second one is filename cats_txt.txt
if n==2:
    filename = sys.argv[1]
    # Using readlines()
    #['cp1252', 'cp850','utf-8','utf8','utf-16','iso-8859-15','cp437']
    #to resolve decoding error tried different encoding types.  encoding='iso-8859-15' worked!
    with open(filename,'r',encoding='iso-8859-15') as file1:   
        #file1 =  codecs.open(filename, 'r', encoding='iso-8859-15') 
        #read lines from the cats_txt.txt file
        lines = file1.readlines()
        words_count = []
        #for each line in lines
        for line in lines: 
            #strip white spaces at beginning and end of line
            line = line.strip()
            #tokenize each line into words
            words =  word_tokenize(line)
            for word in words:
                if word.isalpha():
                    #add it to word_count list
                    words_count.append(word.lower())
            
    #print(pd.Series(words).value_counts())
    #Get the counter for each word in the list
    word_cnt = Counter(words_count)
    #This prints word count ordered from highest count to lowest count
    print(word_cnt)
else:
    print("Pass filename as commandline argument")
   

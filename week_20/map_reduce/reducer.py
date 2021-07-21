#!/usr/bin/env python
#shebang line ^

import sys
import string
from collections import Counter
#import pandas as pd

word = None
print("Reducer!")
words = []
#lines getting passed in from the mapper
for line in sys.stdin:
    line = line.strip()

    word, count = line.split("\t",1)
    words.append(word)
    
#other way to get word count from high to low is doing value_counts on pandas series
#print(pd.Series(words).value_counts())
#Get the counter for each word in the list
word_cnt = Counter(words)
#This prints word count ordered from highest count to lowest count
print(word_cnt)
    

    
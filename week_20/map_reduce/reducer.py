#!/usr/bin/env python
#shebang line ^

import sys
import string
from collections import Counter
#import pandas as pd

current_word = None
current_count = 0
word = None
print("Reducer!")
words = []
#lines getting passed in from the mapper
for line in sys.stdin:
    line = line.strip()

    word, count = line.split("\t",1)
    words.append(word.lower())
    
#print(pd.Series(words).value_counts())
word_cnt = Counter(words)
print(word_cnt)
    

    
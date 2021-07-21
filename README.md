# homework folder
 This folder will hold all my weekly assigments
 
 # Week20 Homework Assignment Question 1
 #### Write a python program (not a Jupyter notebook, but a py file you run from the command line) that accepts the cats_txt.txt file as input and counts the frequency of all words and punctuation in that text file, ordered by frequency. Make sure to handle capital and lowercase versions of words and count them together.
 #### Document how to run the program you created in above question in a readme.md file in your repo. Be as clear as possible. Use proper markdown, and consider using screenshots. Be sure to briefly discuss why this kind of exercise might be helpful for NLP in your markdown. 

## Using mapper and reducer
1. How to call the program
  * cat ./cats_txt.txt|./mapper.py|sort|./reducer.py

2.mapper
  * mapper takes the input from cats_txt.txt file, tokenizes(puncutations are also tokenized using work_tokenize from nltk) and prints only alpha words, changes it to lowercase and prints it

3.reducer
 * reducer takes the sorted output from mapper and uses Counter from collections library to keep the count of words. Prints the word in highest to lowest count order.


## In a single file taking filename as command line parameter
1. How to call the program
   * python week20_homework_Q1.py cats_txt.txt

2. Program checks for command line parameters and takes sys.argv[1] which is filename in this case.
3. Open the file with encoding 
4. readlines from the file
5. tokenize each line, puncutations are also tokenized using work_tokenize from nltk
6. using Counter from collection add each word to Counter.
7. Counter takes care of count for each word and sorting it from highest to lowest.

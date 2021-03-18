"""
Task
Create a function that accepts two values, a and b. Add code to print three lines where:
The first line contains the sum of the two numbers.
The second line contains the difference of the two numbers (first - second).
The third line contains the product of the two numbers.

Conditions:
If any of the results are zero, print “zero” as the result instead of 0 

Note: be sure to include useful info printed out, not just the result
"""
def calc(a,b):
    if type(a) is int and type(b) is int :
        s= a+b
        if s==0:
           s = "zero"
        print("A + b = ",s)
        d = a-b
        if d==0:
           d = "zero"
        print("A - b = " ,d)
        p = a* b
        if p ==0:
           p ="zero"
        print("A * b = " ,p)

calc(3,5)
calc(3,3)
#calc(0,5)        
        

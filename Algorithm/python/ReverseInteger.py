#!/usr/bin/python

# Sample solution - Change to string

class Solution:
    # @return an integer
    def reverse(self, x):
        newstring = str(x)
        
        if newstring[0] == "-":
            result = newstring[0] + newstring[:0:-1]
            return (int(result))
            
        else:
            result = newstring[::-1]
            return (int(result))








# another solution - math 

class Solution:
    # @return an integer
    def reverse(self, x):
        result = 0
        
        flag = 0
        if x < 0:
            flag = 1
            x = -x
        
        while x > 0:
            lastDigit = x - x / 10 * 10
            result = result * 10 + lastDigit
            x /= 10
            
        if flag == 1:
            result = -result          
        
        return result
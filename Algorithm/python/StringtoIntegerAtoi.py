#!/usr/bin/python

class Solution:
    # @return an integer
    def atoi(self, str):
        INT_MAX = 2147483647
        INT_MIN = -2147483648
        
        s = str.strip() 
        
        if len(s) == 0:
            return 0
        
        sign = 1
        if s[0] in '+-':
            if s[0] == '-':
                sign = -1
            s = s[1:]
        
        if s.isdigit():
            s = int(s)
        else:
            i = 0
            while s[i].isdigit():
                i += 1
            if i != 0:
                s = int(s[0:i])
            else: 
                return 0
        
        if s > INT_MAX:  
            return INT_MIN if sign == -1 else INT_MAX  
            
        return s * sign
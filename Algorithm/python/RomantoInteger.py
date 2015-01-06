#!/usr/bin/python

## Roman to Integer ##

class Solution:
    # @return an integer
    def romanToInt(self, s):
        base = [1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1]
        roman = ["M", "CM", "D", "CD", "C", "XC", "L", "XL", "X", "IX", "V", "IV", "I"]
        
        s = s.strip()
        
        # reverse string
        s = s[::-1]
        result = 0
        temp = 0
        
        
        for i in range(len(s)):
            # find s[i] in the list roman
            index = roman.index(s[i])
            num = base[index]
            
            # special condition for roman
            if num < temp:
                num = -num
            else:
                temp = num
            
            result += num
        
        return result
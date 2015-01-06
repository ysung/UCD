#!/usr/bin/python

## Integer to Roman ##

class Solution:
    # @return a string
    def intToRoman(self, num):
        base = [1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1]
        roman = ["M", "CM", "D", "CD", "C", "XC", "L", "XL", "X", "IX", "V", "IV", "I"]
        
        result = ""
        
        i = 0
        while num > 0:
            count = num / base[i]
            num %= base[i]
            
            while count > 0:  
                result += roman[i]  
                count -= 1  
    
            i += 1
            
        return result


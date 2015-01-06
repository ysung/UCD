#!/usr/bin/python


# Three sum,
# Complexity: O(N^2)

# K sum, Complexity: O(N^(K-1))


class Solution:
    # @return a list of lists of length 3, [[val1,val2,val3]]
    def threeSum(self, num):
        numbers = sorted(num)
        solutionSet = []
        
        i = 0
        while i < len(numbers) - 2: 
            if i > 0 and numbers[i] == numbers[i - 1]:
                i += 1
                continue
            
            head = i + 1
            tail = len(numbers) - 1
            
            while head < tail:
                if numbers[i] + numbers[head] + numbers[tail] > 0:
                    tail -= 1
                elif numbers[i] + numbers[head] + numbers[tail] < 0:
                    head += 1
                else:
                    if head != tail and (numbers[i] + numbers[head] + numbers[tail] == 0):
                            solutionSet += [[numbers[i], numbers[head], numbers[tail]]]
                            
                    head += 1
                    tail -= 1
                    
                    while head < tail and numbers[head] == numbers[head - 1]:  
                        head += 1  
                    while head < tail and numbers[tail] == numbers[tail + 1]:  
                        tail -= 1  
                    
            i += 1
                
        return solutionSet


#!/usr/bin/python


# Three sum,
# Complexity: O(N^2)

# K sum, Complexity: O(N^(K-1))

class Solution:
    # @return an integer
    def threeSumClosest(self, num, target):
        numbers = sorted(num)
        result = sum(numbers[0:3])
        
        i = 0
        while i < len(numbers) - 2: 
            if i > 0 and numbers[i] == numbers[i - 1]:
                i += 1
                continue
            
            head = i + 1
            tail = len(numbers) - 1

            while head < tail:
                temp = numbers[i] + numbers[head] + numbers[tail]
                if temp > target:
                    if abs(target - temp) <= abs(target - result):
                        result = temp
                    tail -= 1
                                        
                elif temp < target:
                    if abs(target - temp) <= abs(target - result):
                        result = temp
                    head += 1
                    
                else:
                    if head != tail and (numbers[i] + numbers[head] + numbers[tail] == target):
                        result = target
                    break
                    
            i += 1
                
        return result
        
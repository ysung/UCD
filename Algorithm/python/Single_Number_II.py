# Single Number II 
'''
Given an array of integers, every element appears three times except for one. Find that single one.

Note:
Your algorithm should have a linear runtime complexity. Could you implement it without using extra memory?
'''

class Solution:
    # @param A, a list of integer
    # @return an integer
    def singleNumber(self, A):
        twoSet = set()
        oneSet = set()
        for item in A:
            if item not in oneSet:
                oneSet.add(item)
            elif item in oneSet and item not in twoSet:
                twoSet.add(item)
            else:
                oneSet.remove(item)
        return(oneSet.pop())

# Test

inputs = [2, 4, 1, 2, 4, 1, 5, 5, 5, 2, 1, 3, 4]
Sol = Solution()
print (Sol.singleNumber(inputs))
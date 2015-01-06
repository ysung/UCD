# Reverse Words in a String 

'''
Given an array of integers, every element appears twice except for one. Find that single one.

Note:
Your algorithm should have a linear runtime complexity. Could you implement it without using extra memory?
'''


class Solution:
    # @param A, a list of integer
    # @return an integer
    def singleNumber(self, A):
        twiceSet = set()
        for item in A:
            if item not in twiceSet:
                twiceSet.add(item)
            else:
                twiceSet.remove(item)
        return(twiceSet.pop())


# Test

inputs = [2,4,1,2,4,1,5,3,3]
Sol = Solution()
print (Sol.singleNumber(inputs))
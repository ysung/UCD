#!/usr/bin/python

# Remove Duplicates from Sorted Array 
# O(n)

class Solution:
    # @param a list of integers
    # @return an integer
    def removeDuplicates(self, A):
        if len(A) == 0:
            return 0
        # if len(A) == 1:  # to make it clear
        #     return 1     # (without this also works well)
        
        index = 0
        for i in A[1:]:
            if i != A[index]:
                index += 1
                A[index] = i

        
        return index + 1
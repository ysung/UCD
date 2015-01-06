#!/usr/bin/python


# Four sum,
# Complexity: O(N^2 * logN), O(N^3)

# K sum, Complexity: O(N^(K-1))


# Four sum,
# Complexity: O(N^2 * logN)
# https://oj.leetcode.com/discuss/7926/whats-the-expected-running-time-for-python-solution


import collections
class Solution:
    # @return a list of lists of length 4, [[val1,val2,val3,val4]]
    def fourSum(self, nums, target):
        nums = sorted(nums)
        result = set()
        cache = collections.defaultdict(set)
        for b in range(1, len(nums) - 2):
            for a in range(b):
                cache[nums[a] + nums[b]].add((nums[a], nums[b]))
                print (cache)

            c = b + 1
            for d in range(c + 1, len(nums)):
                remainder = target - nums[c] - nums[d]
                for half in cache[remainder]:
                    result.add(tuple(list(half)  + [nums[c], nums[d]]))
                    print ("r",result)

        return list(map(list, result))

s = Solution()
print (s.fourSum([1, 0, -1, 0, -2, 2], 0))




# Four sum,
# Complexity: O(N^3), TLE

# class Solution:
#     # @return a list of lists of length 4, [[val1,val2,val3,val4]]
#     def fourSum(self, num, target):
#         numbers = sorted(num)
#         solutionSet = []
#         # if numbers == []:
#         #     return SolutionSet
        
#         i = 0
#         while i < len(numbers) - 3: 
#             if i > 0 and numbers[i] == numbers[i - 1]:
#                 i += 1
#                 continue
            
#             j = i+1
            
#             while j < len(numbers) - 2:
#                 if j > 1 and numbers[j] == numbers[j - 1]:
#                     j += 1
#                     continue
                
#                 head = j + 1
#                 tail = len(numbers) - 1
                
#                 while head < tail:
#                     if numbers[i] + numbers[j] + numbers[head] + numbers[tail] > target:
#                         tail -= 1
#                     elif numbers[i] + numbers[j] + numbers[head] + numbers[tail] < target:
#                         head += 1
#                     else:
#                         if head != tail and (numbers[i] + numbers[j] + numbers[head] + numbers[tail] == target):
#                                 solutionSet += [[numbers[i], numbers[j], numbers[head], numbers[tail]]]
                                
#                         head += 1
#                         tail -= 1
                        
#                         while head < tail and numbers[head] == numbers[head - 1]:  
#                             head += 1  
#                         while head < tail and numbers[tail] == numbers[tail + 1]:  
#                             tail -= 1
                            
#                 j += 1
                    
#             i += 1
                
#         return solutionSet


        
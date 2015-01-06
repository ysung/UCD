#!/usr/bin/python


Two Sum,
Complexity: O(N log N)

class Solution:
    # @return a tuple, (index1, index2)
    def twoSum(self, num, target):
        #targetList = [i for i in num if i <= target]
        numbers = sorted(num)
        head = 0
        tail = len(num)-1
        
        while (numbers[head] + numbers[tail]) != target:
            # or head < tail
            if (numbers[head] + numbers[tail]) > target:
                tail -= 1
            elif (numbers[head] + numbers[tail]) < target:
                head += 1
            else:
                break
        
        # find out the original index
        num1 = [i for i, x in enumerate(num, start=1) if x == numbers[head]][0]
        num2 = [i for i, x in enumerate(num, start=1) if (x == numbers[tail] and i != num1)][0]


        # decide the smaller index
        if num1 < num2:
            return (num1, num2)
        else:
            return (num2, num1)


## Two Sum,
## Complexity: O(N), still working

# class Solution:
#     # @return a tuple, (index1, index2)
#     def twoSum(self, num, target):
#         targetNum = [target - i for i in num]
        
#         targetDict = {x: targetNum.count(x) for x in targetNum}

#         if (target//2) in targetDict and targetDict[target//2] == 2:
#             num1 = [key for key, value in targetDict.items() if value == 2]
#             index1, index2 =[i for i, x in enumerate(num, start=1) if x == num1[0]]
#             print(index1, index2)

#         else:
#             for i in range(len(targetNum)):
#                 if targetNum[i] != target / 2 and targetNum[i] in num: 
#                     index1 = num.index(num[i])
#                     index2 = num.index(targetNum[i])
#                     break
            
#         if index1 < index2:
#             return (index1, index2)
#         else:
#             return (index2, index1)




## Sample Solution ##
# Complexity: O(N log N)

# class Solution:
#     # @return a tuple, (index1, index2)
#     def twoSum(self, num, target):
     
#         numbers = sorted(num)

#         length = len(num)
#         left = 0
#         right = length - 1

#         index = []

#         while left < right: 
#             sums = numbers[left] + numbers[right]

#             if sums == target:
#                 for i in range(length):
#                     if num[i] == numbers[left]:
#                         index.append(i + 1)
#                     elif num[i] == numbers[right]:
#                         index.append(i + 1)
                    
#                     if len(index) == 2:
#                         break

#                 break
#             elif sums > target:
#                 right -= 1
#             else:
#                 left += 1

#         result = tuple(index)

#         return result
# Reverse Words in a String 

'''
For example,
Given s = "the sky is blue",
return "blue is sky the".
'''

class Solution:
    # @param s, a string
    # @return a string
    def reverseWords(self, s):
        s = " ".join(s.split())
        terms = s.split(" ")
        terms.reverse()
        results = ' '.join(terms)
        return(results)


# class Solution:
#     # @param s, a string
#     # @return a string
#     def reverseWords(self, s):
#         return ' '.join([word[::-1] for word in s[::-1].split()])




# Test

input_1 = "   a  b "
input_2 = " "
input_3 = "the sky is blue"
Sol = Solution()
#print(Sol.reverseWords(input_3))
print(Sol.reverseWords(input_1), "\n", Sol.reverseWords(input_2), "\n",Sol.reverseWords(input_3))


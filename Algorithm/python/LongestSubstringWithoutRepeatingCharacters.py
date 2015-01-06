#!/usr/bin/python

class Solution:
    # @return an integer
    def lengthOfLongestSubstring(self, s):
        cache = {}
        start = end = 0
        max_length = 0

        while end < len(s):
            if s[end] in cache and cache[s[end]] >= start:
                # the char `s[end]` exists in range [start, end),
                # move start to the next char of prior `s[end]`
                start = cache[s[end]] + 1

            # update the index with latest one
            cache[s[end]] = end
            end += 1
            print ((start, end))

            max_length = max(max_length, end - start)

        return max_length

s = Solution()

print(s.lengthOfLongestSubstring("abcaa"))


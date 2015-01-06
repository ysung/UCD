// LeetCode - Longest Palindromic Substring 
// S1
// Time Complexity: O(n^2)
// Space Complexity: O(1)
// Hint: 每个子串的中心往两边同时进行扫描, 中心的个数为2*n-1(字符作为中心有n个，间隙有n-1个).

/*
Given a string S, find the longest palindromic substring in S. You may assume that the maximum 
length of S is 1000, and there exists one unique longest palindromic substring.
*/

/*
Website: 
http://codeganker.blogspot.com/2014/02/longest-palindromic-substring-leetcode.html
http://www.programcreek.com/2013/12/leetcode-solution-of-longest-palindromic-substring-java/
http://answer.ninechapter.com/solutions/longest-palindromic-substring/

Analysis:
一般有两种方法。 第一种方法比较直接，实现起来比较容易理解。基本思路是对于每个子串的中心
（可以是一个字符，或者是两个字符的间隙，比如串abc,中心可以是a,b,c,或者是ab的间隙，bc的间隙）
往两边同时进行扫描，直到不是回文串为止。假设字符串的长度为n,那么中心的个数为2*n-1
(字符作为中心有n个，间隙有n-1个）。对于每个中心往两边扫描的复杂度为O(n),
所以时间复杂度为O((2*n-1)*n)=O(n^2),空间复杂度为O(1)
*/

// Solution 1
public class Solution {
    public String longestPalindrome(String s) {
        if (s == null || s.length() == 0)
            return "";
            
        int maxLen = 0;
        String res = "";
        for (int i = 0; i < 2*s.length()-1; i++) {
            int left = i/2;
            int right = i/2;
            
            if (i%2 == 1)
                right++;
            
            String str = lengthOfPalindromic(s, left, right);
            if (maxLen < str.length()) {
                maxLen = str.length();
                res = str;
            }
        }
        return res;
    }
    
    private String lengthOfPalindromic(String s, int left, int right) {
        while (left >= 0 && right < s.length() && s.charAt(left) == s.charAt(right)) {
            left--;
            right++;
        }
        return s.substring(left+1, right);
    }
}


// S2
// Time Complexity: O(n^2) with lower constant
// Space Complexity: O(n^2)
// Hint: DP.

// Solution 2 
public class Solution {
	public String longestPalindrome(String s) {
	    if(s == null || s.length() == 0)
	        return "";
	    boolean[][] palin = new boolean[s.length()][s.length()];
	    String res = "";
	    int maxLen = 0;
	    for (int i = s.length()-1; i >= 0; i--) {
	        for (int j = i; j<s.length() ; j++) {
	            if (s.charAt(i) == s.charAt(j) && (j-i <= 2 || palin[i+1][j-1])) {
	            	// 
	                palin[i][j] = true;
	                if (maxLen < j-i+1) {
	                    maxLen = j-i+1;
	                    res = s.substring(i, j+1);
	                }
	            }
	        }
	    }
	    return res;
	}
}



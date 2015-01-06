// LeetCode - Palindrome Number 

// S1
// Time Complexity: O(n)
// Space Complexity: O(1)
// Hint: Math


/*
Determine whether an integer is a palindrome. Do this without extra space.
click to show spoilers.

Some hints:
Could negative integers be palindromes? (ie, -1)     -----> No

If you are thinking of converting the integer to string, note the restriction of using extra space.

You could also try reversing an integer. However, if you have solved the problem "Reverse Integer", 
you know that the reversed integer might overflow. How would you handle such case?

There is a more generic way of solving this problem.
*/


/*
Website:
http://codeganker.blogspot.com/2014/02/palindrome-number-leetcode.html

Analysis:
这道题跟Reverse Integer差不多，也是考查对整数的操作，相对来说可能还更加简单，因为数字不会变化，所以没有越界的问题。
基本思路是每次去第一位和最后一位，如果不相同则返回false，否则继续直到位数为0。
*/

public class Solution {
	public boolean isPalindrome(int x) {
		//negative numbers are not palindrome
	    if (x < 0)
	        return false;
	    
	    // initialize how many zeros
	    int div = 1; 
	    while (div <= x / 10)
	        div *= 10;


	    while (x > 0) {
	    	// check if left equals to right
	        if (x / div != x % 10)
	            return false;

	        // delete left "%div" and right "/10"
	        x = (x % div) / 10;
	        div /= 100;
	    }
	    return true;
	}
}



// S2
// Time Complexity: O(n)
// Space Complexity: O(n), with extra space
// Hint: Math


/*
Website:
https://oj.leetcode.com/discuss/12693/neat-ac-java-code-o-n-time-complexity
*/

public class Solution {
	public boolean isPalindrome(int x) {
		if (x < 0)
	    	return false;


	    int palindromeX = 0;
	    int inputX = x;
	    while (x > 0) {
	        palindromeX = palindromeX * 10 + (x % 10);
	        x = x / 10;
	    }
	    return palindromeX == inputX; 
	}
}

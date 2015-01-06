// LeetCode - Reverse Integer 

// Time Complexity: O(n)
// Space Complexity: O(n)
// Hint: Math


/*
Reverse digits of an integer.

Example1: x = 123, return 321
Example2: x = -123, return -321

click to show spoilers.

Have you thought about this?
Here are some good questions to ask before coding. Bonus points for you if you have already 
thought through this!

If the integer's last digit is 0, what should the output be? ie, cases such as 10, 100.

Did you notice that the reversed integer might overflow? Assume the input is a 32-bit integer, 
then the reverse of 1000000003 overflows. How should you handle such cases?

Throw an exception? Good, but what if throwing an exception is not an option? 
You would then have to re-design the function (ie, add an extra parameter).
*/


/*
Website:
Analysis:
这道题思路非常简单，就是按照数字位反转过来就可以，基本数字操作。但是这种题的考察重点并不在于问题本身，
越是简单的题目越要注意细节，一般来说整数的处理问题要注意的有两点，一点是符号，另一点是整数越界问题。

注意Integer.MIN_VALUE的绝对值是比Integer.MAX_VALUE大1的，所以经常要单独处理。如果不先转为正数也可以，
只是在后面要对符号进行一下判断。这种题目考察的就是数字的基本处理，面试的时候尽量不能错，
而且对于corner case要尽量进行考虑，一般来说都是面试的第一道门槛。
*/


public class Solution {
    public int reverse(int x) {
        if (x == Integer.MIN_VALUE)
            // return Integer.MIN_VALUE;
        	return -1;
    
        int num = Math.abs(x);
        int res = 0;
    
        while (num != 0){
        	// check overflow
            if ( res > (Integer.MAX_VALUE - num % 10) / 10)
                // return x > 0 ? Integer.MAX_VALUE : Integer.MIN_VALUE;
                return -1;
    
            res = res * 10 + num % 10;
            num /= 10;
        }
        return x > 0 ? res : -res;
    }
}

// LeetCode - Climbing Stairs

// Time Complexity: O(n)
// Space Complexity: O(1)
// Hint: DP


/*
You are climbing a stair case. It takes n steps to reach to the top.
Each time you can either climb 1 or 2 steps. 
In how many distinct ways can you climb to the top?
*/


/*
Website:
http://codeganker.blogspot.com/2014/04/climbing-stairs-leetcode.html
http://blog.csdn.net/lilong_dream/article/details/20283023


Analysis:
Each time you can either climb 1 or 2 steps
f(n)=f(n-1)+f(n-2)
費式數列

*/

public class Solution {
    public int climbStairs(int n) {
    	int f1 = 1;
    	int f2 = 2;
    	if (n == 1)
    		return f1;
    	if (n == 2)
    		return f2;

    	for(int i = 3; i <= n; i++) {
    		int f3 = f1 + f2;
    		f1 = f2;
    		f2 = f3;
    	}
        return f3;
    }
}
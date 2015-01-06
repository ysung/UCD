// LeetCode - Sqrt(x) 
// Time Complexity: O(logn)
// Space Complexity: O(1)
// Hint: Binary Search, Math

/*
Implement int sqrt(int x).
Compute and return the square root of x.
*/

/*
Website: 
http://blog.csdn.net/lilong_dream/article/details/20002071
http://ccckmit.wikidot.com/al:sqrt
http://codeganker.blogspot.com/2014/02/sqrtx-leetcode.html

Analysis:
基本思路是跟二分查找类似，要求是知道结果的范围，取定左界和右界，然后每次砍掉不满足条件的一半，
知道左界和右界相遇。算法的时间复杂度是O(logx)，空间复杂度是O(1)
*/


public class Solution {
    public int sqrt(int x) {
    	if (x < 0) return -1;
		if (x == 0 || x == 1) return x;

		int low = 1;
		int high = x / 2; //square root must less than x/2
		int mid = 0;
		int lastMid = 0;

		while (low <= high) {
			mid = (low + high) / 2;
			if (x / mid > mid) {	// x > mid * mid
				low = mid + 1;
				lastMid = mid; 		// for the integer with no integer square root 
			}	
			else if (x / mid < mid)	// x < mid * mid
				high = mid - 1;
			else
				return mid;
    	}
    	return lastMid;
    }
}
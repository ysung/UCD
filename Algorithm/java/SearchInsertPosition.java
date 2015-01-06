// LeetCode - Search Insert Position
// Time Complexity: O(logn)
// Space Complexity: O(1)
// Hint: Binary Search, Array

/*
Given a sorted array and a target value, return the index if the target is found. If not, return the index where it would be if it were inserted in order.

You may assume no duplicates in the array.

Here are few examples.
[1,3,5,6], 5 → 2
[1,3,5,6], 2 → 1
[1,3,5,6], 7 → 4
[1,3,5,6], 0 → 0
*/

/*

/*
Website:
http://blog.csdn.net/lilong_dream/article/details/19768455
http://codeganker.blogspot.com/2014/03/search-insert-position-leetcode.html

Analysis:
二分查找。思路就是每次取中间，如果等于目标即返回，否则根据大小关系切去一半。
因此算法复杂度是O(logn)，空间复杂度O(1)。
注意以上实现方式有一个好处，就是当循环结束时，如果没有找到目标元素，
那么l一定停在恰好比目标大的index上，r一定停在恰好比目标小的index上，所以个人比较推荐这种实现方式。
*/

public class Solution {
    public int searchInsert(int[] A, int target) {
    	if(A == null || A.length == 0)
        	return 0;

        int left = 0;
		int right = A.length - 1;
		int mid = 0;

		while (left <= right) {
			mid = (left + right) / 2;

			if (A[mid] > target)
				right = mid - 1;
			else if (A[mid] < target)
				left = mid + 1;
			else
				return mid;
		}
		return left;
    }
}

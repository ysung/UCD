// LeetCode - Search for a Range 

// S1
// Time Complexity: O(n)
// Space Complexity: O(1)
// Hint: Binary Search, Array

/*
Given a sorted array of integers, find the starting and ending position of a given target value.

Your algorithm's runtime complexity must be in the order of O(log n).

If the target is not found in the array, return [-1, -1].

For example,
Given [5, 7, 7, 8, 8, 10] and target value 8,
return [3, 4].
*/

/*
Website: 
http://blog.csdn.net/lilong_dream/article/details/22893675

Analysis:
1次Binary Search
*/

public class Solution {
    public int[] searchRange(int[] A, int target) {
    	int[] result = {-1, -1};
    	if (A == null || A.length == 0)
    		return result;

        int left = 0;
		int right = A.length - 1;

		while (left <= right) {
			int mid = (left + right) / 2;

			if (A[mid] > target)
				right = mid - 1;
			else if (A[mid] < target)
				left = mid + 1;
			else {
				result[0] = mid;
				result[1] = mid;

				int i = mid - 1;
				// search for left bound
				while (i >= 0 && A[i] == target) {
					result[0] = i;
					--i;
				}

				i = mid + 1;
				// search for right bound
				while (i < A.length && A[i] == target) {
					result[1] = i;
					++i;
				}

				break;
			}
		}

		return result;
    }
}


// S2
// Time Complexity: O(logn)
// Space Complexity: O(1)
// Hint: Binary Search, Array

/*
Website: 
http://codeganker.blogspot.com/2014/03/search-for-range-leetcode.html

Analysis:
3次Binary Search
二分查找找到其中一个target，然后再往左右找到target的边缘。找边缘的方法跟二分查找仍然是一样的，
只是切半的条件变成相等，或者不等（往左边找则是小于，往右边找则是大于）。这样下来总共进行了三次二分查找
*/

public class Solution {
    public int[] searchRange(int[] A, int target) {
        int[] result = {-1, -1};
        if (A == null || A.length ==0)
            return result;

        int left = 0;
		int right = A.length - 1;
		int mid = 0
        
		while (left <= right) {
			mid = (left + right) / 2;

			if (A[mid] > target)
				right = mid - 1;
			else if (A[mid] < target)
				left = mid + 1;
			else {
				result[0] = mid;
				result[1] = mid;
				break;
			}
		}

	    if(A[mid] != target)
	        return result;

	    int rl = mid;
	    int rr = A.length-1;
	    while(rl <= rr) {
	        int rm = (rl + rr) / 2;
	        if(A[rm] == target)
	            rl = rm + 1;
	        else
	            rr = rm - 1;     
	    }
	    result[1] = rr;

	   	int ll = 0;
	    int lr = mid;
	    while(ll <= lr) {
	        int lm = (ll + lr) / 2;
	        if(A[lm] == target)
	            lr = lm - 1;
	        else
	            ll = lm + 1;     
	    }
	    result[0] = ll;

		return result;
    }
}


// S3
// Time Complexity: O(logn)
// Space Complexity: O(1)
// Hint: Binary Search, Array

/*
Website: 
http://codeganker.blogspot.com/2014/03/search-for-range-leetcode.html

Analysis:
2次Binary Search
 如果我们不寻找那个元素先，而是直接相等的时候也向一个方向继续夹逼，如果向右夹逼，最后就会停在右边界，
 而向左夹逼则会停在左边界，如此用停下来的两个边界就可以知道结果了，只需要两次二分查找
*/

public class Solution {
    public int[] searchRange(int[] A, int target) {
        int[] result = {-1, -1};
        if (A == null || A.length ==0)
            return result;
        
        int ll = 0;
        int lr = A.length - 1;
        while (ll <= lr) {
            int m = (ll + lr) / 2;
            if (A[m] < target)
                ll = m + 1;
            else
                lr = m - 1;
        }
        
        int rl = 0;
        int rr = A.length - 1;
        while (rl <= rr) {
            int m = (rl + rr) / 2;
            if (A[m] <= target)
                rl = m + 1;
            else
                rr = m - 1;
        }
        
        if (ll <= rr) {
            result[0] = ll;
            result[1] = rr;
        }
        
        return result;
    }
}



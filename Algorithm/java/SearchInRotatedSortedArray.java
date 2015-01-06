// LeetCode - Search in Rotated Sorted Array

// S1
// Time Complexity: O(logn)
// Space Complexity: O(1)
// Hint: Binary Search, Array

/*
Suppose a sorted array is rotated at some pivot unknown to you beforehand.
(i.e., 0 1 2 4 5 6 7 might become 4 5 6 7 0 1 2).
You are given a target value to search. If found in the array return its index, otherwise return -1.
You may assume no duplicate exists in the array.
*/

/*
Website: 
http://codeganker.blogspot.com/2014/03/search-in-rotated-sorted-array-leetcode.html


Analysis:
这道题是二分查找Search Insert Position的变体，看似有点麻烦，其实理清一下还是比较简单的。
因为rotate的缘故，当我们切取一半的时候可能会出现误区，所以我们要做进一步的判断。
具体来说，假设数组是A，每次左边缘为l，右边缘为r，还有中间位置是m。在每次迭代中，分三种情况：
（1）如果target==A[m]，那么m就是我们要的结果，直接返回；
（2）如果A[m]<=A[r]，那么说明从m到r一定是有序的（没有受到rotate的影响），那么我们只需要判断target是不是在m到r之间，
    如果是则把左边缘移到m+1，否则就target在另一半，即把右边缘移到m-1。
（3）如果A[m]>A[r]，那么说明从l到m一定是有序的，同样只需要判断target是否在这个范围内，相应的移动边缘即可。
    根据以上方法，每次我们都可以切掉一半的数据，所以算法的时间复杂度是O(logn)，空间复杂度是O(1)。


*/

public class Solution {
    public int search(int[] A, int target) {
        if (A == null || A.length == 0)
            return -1;
        
        int l = 0;
        int r = A.length - 1;
        
        while (l <= r) {
            int m = (l + r) / 2;
            if (target == A[m])
                return m;
            
            if (A[m] <= A[r]) {  // right half is sorted
                if (A[m] < target && target <= A[r])
                    l = m + 1;
                else
                    r = m - 1;
            }
            else {               // left half is sorted
                if (A[l] <= target && target < A[m])
                    r = m - 1;
                else
                    l = m + 1;
            }
                    
        }
        
        return -1;
    }
}


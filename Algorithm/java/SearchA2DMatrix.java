// LeetCode - Search a 2D Matrix 

// S1
// Time Complexity: O(logn)
// Space Complexity: O(1)
// Hint: Binary Search, Array, 把matrix視為sorted array, 用"/", "%"來標記midX(row), midY(column)

/*
Write an efficient algorithm that searches for a value in an m x n matrix. 
This matrix has the following properties:

Integers in each row are sorted from left to right.
The first integer of each row is greater than the last integer of the previous row.
For example,

Consider the following matrix:

[
  [1,   3,  5,  7],
  [10, 11, 16, 20],
  [23, 30, 34, 50]
]
*/

/*
Website: 
http://www.programcreek.com/2013/01/leetcode-search-a-2d-matrix-java/

Analysis:
You may try to solve this problem by finding the row first and then the column. 
There is no need to do that. Because of the matrix's special features, 
the matrix can be considered as a sorted array. 
Your goal is to find one element in this sorted array by using binary search.

*/
    public boolean searchMatrix(int[][] matrix, int target) {
        if (matrix == null || matrix.length == 0 || matrix[0].length == 0) 
            return false;
        
        int m = matrix.length;
        int n = matrix[0].length;
        int start = 0;
        int end = m * n - 1;
        
        while (start <= end) {
            int mid = (start + end) / 2;
            int midX = mid / n;         // row
            int midY = mid % n;         // column
            
            if (matrix[midX][midY] == target)
                return true;
            else if (matrix[midX][midY] < target)
                start = mid + 1;
            else
                end = mid - 1;
        }
        
        return false;
    }
}
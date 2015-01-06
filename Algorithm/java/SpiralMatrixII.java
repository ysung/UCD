// Leet Code - Spiral Matrix
// Time Complexity: O(n^2)
// Space Complexity: O(1)


/*
Given an integer n, generate a square matrix filled with elements from 1 to n^2 in spiral order.

For example,
Given n = 3,

You should return the following matrix:
[
 [ 1, 2, 3 ],
 [ 8, 9, 4 ],
 [ 7, 6, 5 ]
]
*/



public class Solution {
    public int[][] generateMatrix(int n) {
	    if (n <= 0) return null;
	    int[][] ret = new int[n][n];

	    int start = 1;
	    int x = 0;
	    int y = 0;
	    for (int i = n; i > 0; i -= 2){
	    	if (i == 1)	ret[x][y] = start;
	    	else {
	    		for (int j = 0; j < i-1; j++)	ret[y][x++] = start++;
	    		// go right
				for (int j = 0; j < i-1; j++)	ret[y++][x] = start++;
				// go down
				for (int j = 0; j < i-1; j++)	ret[y][x--] = start++;
				// go left
				for (int j = 0; j < i-1; j++)	ret[y--][x] = start++;
				// go up     			
				y++;
				x++;
	    	}
	    }
    	return ret;
	}
}
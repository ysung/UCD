// Leet Code - Spiral Matrix
// Time Complexity: O(m*n)
// Space Complexity: O(1)

/*
Given a matrix of m x n elements (m rows, n columns), return all elements of the matrix in spiral order.

For example,
Given the following matrix:

[
 [ 1, 2, 3 ],
 [ 4, 5, 6 ],
 [ 7, 8, 9 ]
]
You should return [1,2,3,6,9,8,7,4,5]
*/

/*
Website: 
http://www.cnblogs.com/hiddenfox/p/3399910.html
http://codeganker.blogspot.com/2014/03/spiral-matrix-leetcode.html

Analysis:
举个例子自己从头到尾把数字列出来，很容易就找到规律了：
假设一维数组的坐标为x，取值范围是xMin~xMax；二维数组的坐标为y，取值范围是yMin~yMax。（也就是数组表示为int[y][x]）
1. 从左到右，y=yMin，x: xMin->xMax，yMin++
2. 从上到下，x=xMax，y: yMin->yMax，xMax--
3. 从右到左，y=yMax，x: xMax->xMin，yMax--
4. 从下到上，x=xMin，y: yMax->uMin，xMin++
结束条件，xMin==xMax或者yMin==yMax
 
还要要注意的地方：空数组的情况要处理。
*/

public static List<Integer> spiralOrder(int[][] matrix) {
    List<Integer> order = new ArrayList<Integer>(); 
    if (matrix == null || matrix.length == 0 || matrix[0].length == 0) return order; 	
    
    int xMin = 0;
    int yMin = 0;
    int xMax = matrix[0].length - 1;
    int yMax = matrix.length - 1;

    order.add(matrix[0][0]);
    
    int i = 0, j = 0;
    while (true) {
        while (i < xMax)    order.add(matrix[j][++i]);
        if (++yMin > yMax)    break;
        // go right
        while (j < yMax)    order.add(matrix[++j][i]);
        if (xMin > --xMax)    break;
        // go down
        while (i > xMin)    order.add(matrix[j][--i]);
        if (yMin > --yMax)    break;
        // go left
        while (j > yMin)    order.add(matrix[--j][i]);
        if (++xMin > xMax)    break;
        // go up
    }
    return order;
}
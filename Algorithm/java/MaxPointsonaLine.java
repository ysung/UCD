// LeetCode - Max Points on a Line 

// Time Complexity: O(n^2)
// Space Complexity: O(n)
// Hint: Math, Hash Table


/*
Given n points on a 2D plane, find the maximum number of points that lie on the same straight line.
*/


/*
Website:
http://codeganker.blogspot.com/2014/03/max-points-on-line-leetcode.html
http://blog.csdn.net/lilong_dream/article/details/20283023


Analysis:
 每次迭代以某一个点为基准， 看后面每一个点跟它构成的直线， 维护一个HashMap， key是跟这个点构成直线的斜率的值， 
 而value就是该斜率对应的点的数量， 计算它的斜率， 如果已经存在， 那么就多添加一个点， 否则创建新的key。 
 这里只需要考虑斜率而不用考虑截距是因为所有点都是对应于一个参考点构成的直线， 只要斜率相同就必然在同一直线上。 
 最后取map中最大的值， 就是通过这个点的所有直线上最多的点的数量。 对于每一个点都做一次这种计算， 
 并且后面的点不需要看扫描过的点的情况了， 因为如果这条直线是包含最多点的直线并且包含前面的点， 
 那么前面的点肯定统计过这条直线了。 因此算法总共需要两层循环， 外层进行点的迭代， 内层扫描剩下的点进行统计， 
 时间复杂度是O（n^2), 空间复杂度是哈希表的大小， 也就是O（n), 比起上一种做法用这里用哈希表空间省去了一个量级的时间复杂度。


*/

/**
 * Definition for a point.
 * class Point {
 *     int x;
 *     int y;
 *     Point() { x = 0; y = 0; }
 *     Point(int a, int b) { x = a; y = b; }
 * }
 */

public class Solution {
    public int maxPoints(Point[] points) {
        if (points == null || points.length == 0)
            return 0;
        int max = 1;
        double slope = 0.0;

        for (int i = 0; i < points.length - 1; i++) {
            HashMap<Double, Integer> map = new HashMap<Double, Integer>();
            int numofSame = 0;
            int localMax =1;
            for (int j = i + 1; j < points.length - 1; j++) {
                if (points[j].x == points[i].x && points[j].y == points[i].y) {
                    numofSame++;
                    continue;
                }
                else if (points[j].x == points[i].x) {
                    slope = (double) Integer.MAX_VALUE;

                }
                else if (points[j].y == points[i].y) {
                    slope = 0.0;
                }
                else {
                    slope = (double) (points[j].y - points[i].y) / (double) (points[j].x - points[i].x);
                }

                if (map.containsKey(slope)) {
                    map.put(slope, map.get(slope) + 1);
                } else {
                    map.put(slope, 2);
                }
            }

            for (Integer value : map.values()) {
                localMax = Math.max(localMax, value);
            }
            localMax += numofSame;
            max = Math.max(max, localMax);
        }
        return max;
    }
}

// Change the way to find max, same complexity
public class Solution {
    public int maxPoints(Point[] points) {
        if (points == null || points.length == 0)
            return 0;
        int max = 1;
        double slope = 0.0;
        
        for (int i = 0; i < points.length - 1; i++) {
            HashMap<Double, Integer> map = new HashMap<Double, Integer>();
            int numofSame = 0;
            int localMax =1;

            for (int j = i + 1; j < points.length; j++) {
                if (points[j].x == points[i].x && points[j].y == points[i].y) {
                    numofSame++;
                    continue;
                }
                else if (points[j].x == points[i].x) {
                    slope = Double.MAX_VALUE;

                }
                else if (points[j].y == points[i].y) {
                    slope = 0.0;
                }
                else {
                    slope = 1.0 * (points[j].y - points[i].y) / (points[j].x - points[i].x);
                }

                if (map.containsKey(slope)) {
                    map.put(slope, map.get(slope) + 1);
                } else {
                    map.put(slope, 2);
                }
                
                if (map.get(slope) > localMax)
                    localMax = map.get(slope);
            }
            
            localMax += numofSame;
            if (localMax > max)
                max = localMax;
        }
        return max;
    }
}
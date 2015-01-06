// LeetCode - Divide Two Integers

// Time Complexity: O(logn)
// Space Complexity: O(1)
// Hint: Math, Binary Search


/*
Divide two integers without using multiplication, division and mod operator.
*/


/*
Website:
http://codeganker.blogspot.com/2014/02/divide-two-integers-leetcode.html
http://www.ninechapter.com/solutions/divide-two-integers/


Analysis:
我们知道任何一个整数可以表示成以2的幂为底的一组基的线性组合，即num=a_0*2^0+a_1*2^1+a_2*2^2+...+a_n*2^n。
基于以上这个公式以及左移一位相当于乘以2，我们先让除数左移直到大于被除数之前得到一个最大的基。
然后接下来我们每次尝试减去这个基，如果可以则结果增加加2^k，然后基继续右移迭代，直到基为0为止。
因为这个方法的迭代次数是按2的幂直到超过结果，所以时间复杂度为O(logn)

15 / 3 = 5
divisor 除數 3
dividend 被除數 15
quotient 商數 5
remainder 餘數 0
*/


public class Solution {

    public int divide(int dividend, int divisor) {
        if(divisor == 0)
            return Integer.MAX_VALUE;
    
        if(dividend == Integer.MIN_VALUE && divisor == -1)
        {
            return Integer.MAX_VALUE;
        }
        
        
        
        boolean negative = (dividend > 0 && divisor < 0) ||
            (dividend < 0 && divisor > 0);

        long a = Math.abs((long)dividend);
        long b = Math.abs((long)divisor);
        int ans = 0;

        while (a >= b) {
            int shift = 0;
            while (b <= (a >> shift)) {
                shift++;
            }
            ans += 1 << (shift-1);
            a = a - (b << (shift-1));
        }

        return negative ? -ans : ans;
    }
}

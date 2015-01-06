// LeetCode - Pow(x, n)

// S1
// Time Complexity: O(logn)
// Space Complexity: O(1)
// Hint: Math, Binary Search, recursion


/*
website:
http://codeganker.blogspot.com/2014/02/powx-n-leetcode.html


Analysis:
*/

public class Solution {
    public double pow(double x, int n) {
        if(n==0)
            return 1.0;
        double res = 1.0;   
        if(n<0)
        {
            if(x>=1.0/Double.MAX_VALUE||x<=-1.0/Double.MAX_VALUE)
                x = 1.0/x;
            else
                return Double.MAX_VALUE;
            if(n==Integer.MIN_VALUE)
            {
                res *= x;
                n++;
            }
        }
        n = Math.abs(n);
        boolean isNeg = false;
        if(n%2==1 && x<0)
        {
            isNeg = true;
        }
        x = Math.abs(x);
        while(n>0)
        {
            if((n&1) == 1)
            {
                if(res>Double.MAX_VALUE/x)
                    return Double.MAX_VALUE;
                res *= x;
            }
            x *= x;
            n = n>>1;
        }
        return isNeg?-res:res;
    }
}



// S2
// Time Complexity: O(logn)
// Space Complexity: O(1)
// Hint: Math, Binary Search, recursion

/*
website:
http://codeganker.blogspot.com/2014/02/powx-n-leetcode.html

Analysis:
把x的n次方划分成两个x的n/2次方相乘，然后递归求解子问题，结束条件是n为0返回1。
因为是对n进行二分，算法复杂度O(logn)，以上代码比较简洁，不过这里有个问题是没有做越界的判断，
因为这里没有统一符号，所以越界判断分的情况比较多，不过具体也就是在做乘除法之前判断这些值会不会越界
*/

// x^n = x^(n/2) * x^(n/2) * x^(n%2)
// if n is an odd n%2 = 0
// if n is an even n%2 = 1

public class Solution {
    public double pow(double x, int n) {
    	if (n == 0) return 1.0;

    	double half = pow(x, n/2);
    	if (n % 2 == 0)
    		return half * half;
    	else if (n > 0)
    		return half * half * x;
    	else
    		return half * half / x;
    }
}

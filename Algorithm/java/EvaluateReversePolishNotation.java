// Leet Code - Evaluate Reverse Polish Notation 
// Time Complexity: O(n)
// Space Complexity: O(1)
// Hint: postfix, stack

/*
Evaluate the value of an arithmetic expression in Reverse Polish Notation.

Valid operators are +, -, *, /. Each operand may be an integer or another expression.

Some examples:
  ["2", "1", "+", "3", "*"] -> ((2 + 1) * 3) -> 9
  ["4", "13", "5", "/", "+"] -> (4 + (13 / 5)) -> 6
*/


/*
Website: 
http://blog.csdn.net/lilong_dream/article/details/20204273
http://answer.ninechapter.com/solutions/evaluate-reverse-polish-notation/
http://www.programcreek.com/2012/12/leetcode-evaluate-reverse-polish-notation/

Analysis:

*/

public class Solution {
    public int evalRPN(String[] tokens) {
		String operators = "+-*/";
		Stack<Integer> s = new Stack<Integer>();

		if(tokens==null || tokens.length==0)
        	return 0;

		for (String str : tokens) {
			if (!operators.contains(str)) {
				s.push(Integer.valueOf(str));
				continue;
			}

			int num2 = s.pop();
			int num1 = s.pop();

            if(str.equals("+")) 
                s.push(num1 + num2);
            else if(str.equals("-")) 
                s.push(num1 - num2);
            else if(str.equals("*")) 
                s.push(num1 * num2);
            else 
                s.push(num1 / num2);
            
		}
		return s.pop();
    }
}
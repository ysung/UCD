# Definition for singly-linked list.
# class ListNode:
#     def __init__(self, x):
#         self.val = x
#         self.next = None

class Solution:
    # @param a ListNode
    # @return a ListNode
    def swapPairs(self, head):
        if head == None or head.next == None:
            return head
            
        dummy = ListNode(0) 
        dummy.next = head
        p = dummy

        while p.next and p.next.next:
            tmp = p.next.next   # 0 A "B" C
            p.next.next = tmp.next  # 0 A C
            tmp.next = p.next   # B A C
            p.next = tmp        # 0 B A C
            
            p = p.next.next
            # next round
            
            
        return dummy.next
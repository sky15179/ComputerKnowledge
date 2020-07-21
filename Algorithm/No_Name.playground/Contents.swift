//: A UIKit based Playground for presenting user interface

import UIKit


public class ListNode {
     public var val: Int
     public var next: ListNode?
     public init(_ val: Int) {
         self.val = val
         self.next = nil
     }
 }

//public class TreeNode {
//    public var val: Int
//    public var left: TreeNode?
//    public var right: TreeNode?
//    public init(_ val: Int) {
//        self.val = val
//        self.left = nil
//        self.right = nil
//    }
//}
//
//class Find {
//    static func dfs(root: TreeNode?, target: TreeNode) {
//
//    }
//
//    static func dfs2(root: TreeNode?, target: TreeNode) -> Bool {
//        guard let root = root else { return false }
//        var nodeStack: [TreeNode] = []
//        nodeStack.append(root)
//        while !nodeStack.isEmpty {
//            var node = nodeStack.popLast()
//            if let left = node?.left {
//                nodeStack.append(left)
//            }
//            if let right = node?.right {
//                nodeStack.append(right)
//            }
//        }
//        return false
//    }
//
//    static func bfs(root: TreeNode?) {
//
//    }
//}
//
//var set = Set<Int>()

//class Solution {
//    static func deleteDuplicates(_ head: ListNode?) -> ListNode? {
//        let dummy = ListNode(0)
//        dummy.next = head
//        var cur: ListNode? = dummy
//        while cur?.next != nil, cur?.next?.next != nil {
//            if cur?.next?.val == cur?.next?.next?.val {
//                var temp = cur?.next
//                while temp != nil, temp?.next != nil, temp?.val == temp?.next?.val {
//                    temp = temp?.next
//                }
//                cur = temp?.next
//            } else {
//                cur = cur?.next
//            }
//        }
//
//        return dummy.next
//    }
//}

var mutableArray = [1,2,3]
mutableArray.count
for _ in mutableArray {
    mutableArray.removeLast()
}
mutableArray.count
enum Either<T, V> {
  case Left(T)
  case Right(V)
}

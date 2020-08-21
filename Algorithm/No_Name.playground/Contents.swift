//: A UIKit based Playground for presenting user interface

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

//二叉树相关问题的两种解题思路：自顶向下（前序遍历）: 快速排序，自底向上（后序遍历）：归并排序

var arr = [1,2,3]

public class TreeNode {
    public var val: Int
    public var left: TreeNode?
    public var right: TreeNode?
    public init(_ val: Int) {
        self.val = val
        self.left = nil
        self.right = nil
    }
}

func lowestCommonAncestor(_ root: TreeNode?, _ p: TreeNode?, _ q: TreeNode?) -> TreeNode? {
    //问题是从子节点开始向上递推出结果所以是后序遍历
    if root == nil || p === root || q === root {
        return root
    }
    let left = lowestCommonAncestor(root?.left, p, q)
    let right = lowestCommonAncestor(root?.right, p, q)
    if left == nil { return right }
    if right == nil { return left }
    return root
}
 
class Solution {
    var path: [Int] = []

    func hasPathSum(_ root: TreeNode?, _ sum: Int) -> Bool {
        //分类：回溯，找出满足条件的第一个解然后退出
        guard let root = root else { return false }
        return backTrack(root, sum)
    }

    func backTrack(_ root: TreeNode?, _ sum: Int) -> Bool {
        guard let root = root else { return false }
        var newSum = sum
        //选择
        path.append(root.val)

        //状态变化操作
        newSum -=  root.val
        //终止条件
        if newSum == 0 && root.left == nil && root.right == nil {
            return true
        }
        backTrack(root.left, newSum)
        backTrack(root.right, newSum)
        //撤销选择
        path.removeLast()
        return false
    }
    
    func buildTree(_ preorder: [Int], _ inorder: [Int]) -> TreeNode? {
        return helper(preorder, preStart: 0, preEnd: preorder.count - 1, inorder, inStart: 0, inEnd: inorder.count - 1)
    }

    func helper(_ preorder: [Int], preStart: Int, preEnd: Int, _ inorder: [Int], inStart: Int, inEnd: Int) -> TreeNode? {
        if preStart == preEnd { return nil }
        let root = TreeNode(preorder[preStart])
        let inRoot = inorder.findIndex { $0 == preorder[0] }
        guard let rinRoot = inRoot else { return nil }
        let leftNums = rinRoot - inStart
        root.left = helper(preorder, preStart: preStart + 1, preEnd:preStart + leftNums + 1, inorder, inStart: inStart, inEnd: rinRoot)
        root.right = helper(preorder, preStart: preStart + leftNums + 1, preEnd:preEnd, inorder, inStart: rinRoot + 1, inEnd: inEnd)
        return root
    }
}

extension Array {
    func findIndex(_ condition: (Element) -> Bool) -> Int? {
        for (index, value) in self.enumerated() {
            if condition(value) {
                return index
            }
        }
        return nil
    }
}

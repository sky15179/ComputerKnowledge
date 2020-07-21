//: A UIKit based Playground for presenting user interface

import UIKit

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
 
class Solution {
    func rightSideView(_ root: TreeNode?) -> [Int] {
        guard root != nil else { return [] }
        var rightMostValueDepth: [Int: Int] = [:]
        var max_depth = -1
        var nodeStack: [TreeNode?] = []
        var depthStack: [Int] = []
        nodeStack.append(root)
        depthStack.append(0)
        var result: [Int] = []
        
        while !nodeStack.isEmpty {
            let node = nodeStack.popLast()
            let depth = depthStack.popLast()
            if let node = node, let rnode = node {
                if let depth = depth {
                    max_depth = Swift.max(max_depth, depth)
                    if !rightMostValueDepth.keys.contains(depth) {
                        rightMostValueDepth[depth] = rnode.val
                    }
                }
                nodeStack.append(rnode.left)
                nodeStack.append(rnode.right)
                if let depth = depth {
                    depthStack.append(depth+1)
                    depthStack.append(depth+1)
                }
            }
        }
        for depth in 0..<max_depth {
            if let val = rightMostValueDepth[depth] {
                result.append(val)
            }
        }
        return result
    }
    
    func rightSideView2(_ root: TreeNode?) -> [Int] {
        guard root != nil else { return [] }
        var rightMostValueDepth: [Int: Int] = [:]
        var max_depth = -1
        var nodeQueue: [TreeNode?] = []
        var depthQueue: [Int] = []
        nodeQueue.append(root)
        depthQueue.append(0)
        var result: [Int] = []
        
        while !nodeQueue.isEmpty {
            let node = nodeQueue.removeLast()
            let depth = depthQueue.removeLast()
            if let rnode = node {
                max_depth = Swift.max(max_depth, depth)
                if !rightMostValueDepth.keys.contains(depth) {
                    rightMostValueDepth[depth] = rnode.val
                }
                nodeQueue.append(rnode.left)
                nodeQueue.append(rnode.right)
                depthQueue.append(depth+1)
                depthQueue.append(depth+1)
            }
        }
        for depth in 0..<max_depth {
            if let val = rightMostValueDepth[depth] {
                result.append(val)
            }
        }
        return result
    }
}

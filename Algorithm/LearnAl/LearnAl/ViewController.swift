//
//  ViewController.swift
//  LearnAl
//
//  Created by 王智刚 on 2020/7/27.
//  Copyright © 2020 王智刚. All rights reserved.
//

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

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        print(Solution().reversePairs([7,5,6,4]))
//        print(Solution().minPathSum([[1,3,1],[1,5,1],[4,2,1]]))
//        print(Solution().coinChange([1], 1))
//        print(Solution().maxProfit([7,1,5,3,6,4]))
//    print(Solution().minimumTotal([[-10]]))
//        print(Solution().isMatch("aab", "c*a*b"))
//        print(Solution().isSymmetric([1,2,2,3,4,4,3]))
//        print(Solution().buildTree([3,9,20,15,7], [9,3,15,20,7]))
    }
}

class Solution {
    
    func buildTree(_ preorder: [Int], _ inorder: [Int]) -> TreeNode? {
        guard preorder.count > 0 && inorder.count > 0 else { return nil }
        return helper(preorder, preStart: 0, preEnd: preorder.count - 1, inorder, inStart: 0, inEnd: inorder.count - 1)
    }

    func helper(_ preorder: [Int], preStart: Int, preEnd: Int, _ inorder: [Int], inStart: Int, inEnd: Int) -> TreeNode? {
        if preStart == preEnd { return nil }
        let root = TreeNode(preorder[preStart])
        let inRoot = inorder.findIndex { $0 == preorder[preStart] }
        guard let rinRoot = inRoot else { return nil }
        let leftNums = rinRoot - inStart
        root.left = helper(preorder, preStart: preStart + 1, preEnd:preStart + leftNums + 1, inorder, inStart: inStart, inEnd: rinRoot)
        root.right = helper(preorder, preStart: preStart + leftNums + 1, preEnd:preEnd, inorder, inStart: rinRoot + 1, inEnd: inEnd)
        return root
    }
    
    
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
        if backTrack(root.left, newSum) { return true }
        if backTrack(root.right, newSum) { return true }
        //撤销选择
        path.removeLast()
        return false
    }
    
    func isSymmetric(_ root: TreeNode?) -> Bool {
        guard root != nil else { return false }
        let arr = bfs(root)
        for nums in arr {
            if !isReveredArray(nums) {
                return false
            }
        }
        return true
    }

    func bfs(_ root: TreeNode?) -> [[Int]] {
        guard let root = root else { return [] }
        var queue: [TreeNode] = []
        var res: [[Int]] = []
        queue.append(root)
        while !queue.isEmpty {
            let size = queue.count
            var curArr: [Int] = []
            for _ in 0..<size {
                let r = queue.removeFirst()
                curArr.append(r.val)
                if let l = r.left {
                    queue.append(l)
                }
                if let rn = r.right {
                    queue.append(rn)
                }
            }
            res.append(curArr)
        }
        return res
    }

    func isReveredArray(_ nums: [Int]) -> Bool {
        var left = 0
        var right = nums.count - 1
        while left < right {
            if left != right {
                return false
            }
            left += 1
            right -= 1
        }
        return true
    }
    
    func minimumTotal(_ triangle: [[Int]]) -> Int {
        guard triangle.count > 0 else {
            return 0 }
        guard triangle.count > 1 else {
            return triangle[0][0]
        }
        var dp: [[Int]] = triangle
        for i in 1...triangle.count - 1 {
            for j in 0...triangle[i].count - 1 {
                if i == 0 && j == 0 {
                    continue
                } else if j == 0 {
                    dp[i][j] = dp[i - 1][j]  + dp[i][j]
                } else if j == triangle[i].count - 1 {
                    dp[i][j] = dp[i - 1][j - 1]  + dp[i][j]
                } else {
                    dp[i][j] = Swift.min(dp[i - 1][j], dp[i - 1][j - 1]) + dp[i][j]
                }
            }
        }
        
        var min = Int.max
        for num in dp[dp.count - 1] {
            if num < min {
                min = num
            }
        }
        return min
    }
    
    func maxProfit(_ prices: [Int]) -> Int {
          //状态1：所有价格，状态2：剩下的价格
          //求两状态差值，每次记录更大值
          //使用状态数组即可
          //最后的结果是选出dp数组中最大值
          //到这步都是回溯的解决
          //动态规划的优化：状态累计的方程是？
          var dp: [Int] = Array(repeating: 0, count: prices.count + 1) //这里如果有价格为状态的情况需要特殊处理，可以通过 + 1 构建哨兵来排除特殊情况
          for i in 0...prices.count - 1 {
              for j in i...prices.count - 1 {
                  if prices[j] - prices[i] > 0 {
                      dp[i] = Swift.max(prices[j] - prices[i], dp[i])
                  }
              }
          }
          var maxValue = 0
          for i in dp {
              maxValue = Swift.max(i, maxValue)
          }
          return maxValue
      }
    
    //零钱兑换
    func coinChange(_ coins: [Int], _ amount: Int) -> Int {
        //记录最后满足结果的dp数组即可
        var dp: [Int] = Array(repeating: amount, count: amount + 1)
        for i in 0...amount {
            for coin in coins {
                if i - coin < 0 { continue }
                dp[i] = Swift.min(dp[i], dp[i - coin] + 1)
            }
        }
        return dp[amount] == amount ? -1 : dp[amount]
    }
    
    func minPathSum(_ grid: [[Int]]) -> Int {
        //每次能走的是向下或右， 动态规划，f(i, j) = min(f(i - 1, j), f(i, j - 1)) + grid[i][j]
        //状态转移方程：f(i, j) = grid[i][j] + min(f(i-1, j), f (i，j)))
        var dpArr: [[Int]] = grid
        for i in 0...grid.count - 1 {
            for j in 0...grid[0].count - 1 {
                if i == 0 && j == 0 {
                    continue
                } else if i == 0 {
                    dpArr[i][j] = grid[i][j - 1] + dpArr[i][j]
                } else if j == 0 {
                    dpArr[i][j] = grid[i - 1][j] + dpArr[i][j]
                } else {
                    dpArr[i][j] = grid[i][j] + Swift.min(dpArr[i - 1][j], dpArr[i][j - 1])
                }
            }
        }
    
        return dpArr[grid.count - 1][grid[0].count - 1]
    }

//    func reversePairs(_ nums: [Int]) -> Int {
//        guard nums.count > 1 else { return 0 }
//        var result = 0
//
//        //分解
//        func mergeSort2(arr: [Int]) -> [Int] {
//            guard arr.count > 1 else { return arr }
//            let mid = arr.count / 2
//            let larr = mergeSort2(arr: Array(arr[0..<mid]))
//            let rarr = mergeSort2(arr: Array(arr[mid..<arr.count]))
//            return merge(leftArr: larr, rightArr: rarr)
//        }
//
//        //合并
//        func merge(leftArr: [Int], rightArr: [Int]) -> [Int] {
//            var i = 0
//            var j = 0
//            var resultArr: [Int] = []
//
//            while i < leftArr.count && j < rightArr.count {
//                if leftArr[i] <= rightArr[j] {
//                    resultArr.append(leftArr[i])
//                    i += 1
//                } else {
//                    //记录逆序对，当右数组元素大于左数组元素, 左边中剩下都是逆序对的
//                    result += leftArr.count - i
//                    resultArr.append(rightArr[j])
//                    j += 1
//                }
//            }
//
//            while i < leftArr.count {
//                resultArr.append(leftArr[i])
//                i += 1
//            }
//
//            while j < rightArr.count {
//                resultArr.append(rightArr[j])
//                j += 1
//            }
//            return resultArr
//        }
//
//        _ = mergeSort2(arr: nums)
//
//        return result
//    }
    
    //正则表达式匹配
    func isMatch(_ s: String, _ p: String) -> Bool {
        //解题思路：多状态使用状态表
        /* 状态转变情况
         1. p[j] == s[i] : dp[i][j] = dp[i - 1][j - 1]
         2. p[j] == "." : dp[i][j] = dp[i - 1][j - 1]
         3. p[j] == "*":
                        (1). p[j - 1] != s[i] : dp[i][j] = dp[i][j - 2]
                        (2). p[j - 1] == s[i] || p[j - 1] == ".":
                                                a.dp[i][j] = dp[i - 1][j]
                                                b.dp[i][j] == s[i][j - 1]
                                                c.dp[i][j] == s[i][j - 2]
         */
        //dp = d[i - 1][j - 1] + (si 对比 pj)
        guard s.count > 0 && p.count > 0 else {
            return false
        }
        //状态表
        var dp: [[Bool]] = Array(repeating: Array(repeating: false, count: p.count + 1), count: s.count + 1)
        //状态表初始化
        dp[0][0] = true
        
        //状态表状态填充
        for i in 1..<s.count {
            for j in 1..<p.count {
                if p[j - 1] == "." || p[j - 1] == s[i - 1] {
                    dp[i][j] = dp[i - 1][j - 1]
                }
                if p[j - 1] == "*" {
                    if p[j - 2] != s[i - 1] && p[j - 2] != "." {
                        dp[i][j] = dp[i][j - 2]
                    } else {
                        dp[i][j] = dp[i][j - 1] || dp[i][j - 1] || dp[i][j - 2]
                    }
                }
            }
        }
        return dp[s.count - 1][p.count - 1]
    }
}

extension String {
    
    subscript(i: Int) -> String {
        guard i >= 0 && i < count else { return "" }
        return String(self[index(startIndex, offsetBy: i)])
    }
    
    subscript(range: Range<Int>) -> String {
        let lowerIndex = index(startIndex, offsetBy: max(0, range.lowerBound), limitedBy: endIndex) ?? endIndex
        let higherIndex = index(lowerIndex, offsetBy: range.upperBound - range.lowerBound, limitedBy: endIndex) ?? endIndex
        return String(self[lowerIndex..<higherIndex])
    }
    
    subscript(range: ClosedRange<Int>) -> String {
        let lowerIndex = index(startIndex, offsetBy: max(0, range.lowerBound), limitedBy: endIndex) ?? endIndex
        let higherIndex = index(lowerIndex, offsetBy: range.upperBound - range.lowerBound + 1, limitedBy: endIndex) ?? endIndex
        return String(self[lowerIndex..<higherIndex])
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

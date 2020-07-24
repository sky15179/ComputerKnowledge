//: A UIKit based Playground for presenting user interface
  
import UIKit

//动态规划：记录所有叠加可能状态的map，根据map来求解
//背包问题：对于一组不同重量、不可分割的物品，我们需要选择一些装入背包，在满足背包最大重量限制的前提下，背包中物品总重量的最大值是多少呢
//思路: 使用状态维度构建所有状态表
private let maxW = Int.max //当前最大重量
private let weight: [Int] = [2, 2, 4, 6, 3]
private let value = [3, 4, 8, 9, 6] // 物品的价值
private let n = 5 //物品个数
private let w = 9 //最大重量

//weight:物品重量，n:最大数量，w:要求的最大重量
func knapsack(weight: [Int],n: Int, w: Int) -> Int {
    var statesMap: [[Bool]] = Array(repeating: Array(repeating: false, count: w + 1), count: n)
    //跳过初始首行状态
    statesMap[0][0] = true
    if weight[0] <= w {
        statesMap[0][weight[0]] = true
    }
    
    for i in 1...n { //剩余的所有的重量状态
        //不放入物品
        for j in 0...w {
            if statesMap[i - 1][j] { statesMap[i][j] = statesMap[i - 1][j] }
        }
        
        //放入物品
        for j in 0...w - weight[i] {
            if statesMap[i - 1][j] { statesMap[i][j + weight[i]] = true }
        }
    }
    
    //从最末的状态向前迭代找到第一个合适的结果
    for i in (0...w).reversed() {
        if statesMap[n-1][i] { return i }
    }
    
    return 0
}

//优化：如果只求出最优解，只需要保留最新一行数据即可
func knapsack2(weight: [Int],n: Int, w: Int) -> Int {
    var statesMap: [Bool] = Array(repeating: false, count: w + 1)
    //跳过初始首行状态
    statesMap[0] = true
    if weight[0] <= w {
        statesMap[weight[0]] = true
    }
    
    for i in 1...n { //剩余的所有的重量状态
        //放入物品，这里逆序为了避免重复计算
        for j in (0...w - weight[i]).reversed() {
            if statesMap[j] { statesMap[j + weight[i]] = true }
        }
    }
    
    //从最末的状态向前迭代找到第一个合适的结果
    for i in (0...w).reversed() {
        if statesMap[i] { return i }
    }
    
    return 0
}

//升级问题：选出最优解中最高价值的具体解决方案, 状态表存储的是当前价值总值
func knapsack3(weight: [Int],n: Int, w: Int) -> Int {
    var statesMap: [[Int]] = Array(repeating: Array(repeating: 0, count: w + 1), count: n)
    //跳过初始首行状态
    statesMap[0][0] = 0
    if weight[0] <= w {
        statesMap[0][weight[0]] = value[0]
    }
    
    for i in 1...n { //剩余的所有的重量状态
        //不放入物品
        for j in 0...w {
            if statesMap[i - 1][j] >= 0 { statesMap[i][j] = statesMap[i - 1][j] }
        }
        
        //放入物品
        for j in 0...w - weight[i] {
            if statesMap[i - 1][j] >= 0 {
                let v = value[i - 1] + value[i]
                if v > statesMap[i][j + weight[i]] {
                    statesMap[i][j + weight[i]] = v
                }
            }
        }
    }
    
    var max = -1
    for i in (0...w) {
        if statesMap[n-1][i] > max {
            max = statesMap[n-1][i]
        }
    }
    return max
}

//问题：淘宝的“双十一”购物节有各种促销活动，比如“满 200 元减 50 元”。假设你女朋友的购物车中有 n 个（n>100）想买的商品，她希望从里面选几个，在凑够满减条件的前提下，让选出来的商品价格总和最大程度地接近满减条件（200 元），这样就可以极大限度地“薅羊毛”
//items:商品价格， n:商品个数, 最大限制：满200
func double11advance(items: [Int], n: Int, w: Int) {
    var statesMap: [[Bool]] = Array(repeating: Array(repeating: false, count: 3 * w), count: n)
    statesMap[0][0] = true
    if items[0] <= 3 * w {
        statesMap[0][items[0]] = true
    }
        
    for i in 1...n {
        //不购买
        for j in 0...(3 * w) {
            if statesMap[i - 1][j] { statesMap[i][j] = statesMap[i - 1][j] }
        }
        
        //购买
        for j in 0...(3 * w) - items[i] {
            if statesMap[i - 1][j] { statesMap[i][j + items[i]] = true }
        }
    }
    
    var value = 0
    for j in w...(3 * w + 1) {
        value = j
        if statesMap[n-1][j] { break } //得到满足条件的最小值
    }
    if value == (3 * w + 1) { return }
    for i in 1...n-1 {
        if value - items[i] >= 0 && statesMap[i - 1][value - items[i]] {
            print("\(items[i]) ") //购买
            value = value - items[i]
        }
    }
    if value != 0 { print("\(items[0]) ") }
}

//问题：杨辉三角

//问题：二维数组最短路径, 状态转移链表，状态转移方程

//问题：硬币找零问题，我们在贪心算法那一节中讲过一次。我们今天来看一个新的硬币找零问题。假设我们有几种不同币值的硬币 v1，v2，……，vn（单位是元）。如果我们要支付 w 元，求最少需要多少个硬币。比如，我们有 3 种不同的硬币，1 元、3 元、5 元，我们要支付 9 元，最少需要 3 个硬币（3 个 3 元的硬币）
//到n的问题可以先实例化个具体值求解再找规律, w = 9, items = [1, 3, 5]
//转移方程 f(9) = 1 + min(f(8), f(6), f(4))
let mItems = [1, 3, 5]
let mw = 9
let mn = 3
//找出状态转移方程，使用递归解决：找出base情况，退出条件，递归方程
//求n的问题解决方式：
//1.举出实例找规律
//2.分解求n过程: 找出基本解
func zhaoLing2(items: [Int], n: Int, w: Int) -> Int {
    var states = Array(repeating: 0, count: w)
    states[1] = 1
    states[2] = 2
    states[3] = 1
    states[4] = 2
    states[5] = 1
    for i in 6...n {
        states[i] = 1 + Swift.min(states[i - 1], states[i - 3], states[i - 5])
    }
    return states[n]
}

//dp表：自下向上
func coinChange2(_ coins: [Int], _ amount: Int) -> Int {
    var dp = Array(repeating: amount + 1, count: amount + 1)
    //base
    dp[0] = 0
    for i in 0...dp.count {
        for coin in coins {
            if i - coin < 0 { continue }
            dp[i] = Swift.min(dp[i], dp[i - coin] + 1)
        }
    }
    //注意这里返回的是数组的最大界限值
    return dp[amount] == amount + 1 ? -1 : dp[amount]
}

//备忘录：自上向下
func coinChange(_ coins: [Int], _ amount: Int) -> Int {
    //备忘录
    var dict: [Int: Int] = [:]

    //dp方程
    func dp(n: Int) -> Int {
        //base
        if let cache = dict[n] { return cache }
        if n == 0 { return 0 }
        if n < 0 { return -1 }
        var res = Int.max
        for coin in coins {
            let sub = dp(n: n - coin)
            if sub == -1 { continue }
            res = Swift.min(res, sub + 1)
        }
        //这里需要对有效性做判断
        dict[n] = res == Int.max ? -1 : res
        return dict[n] ?? 0
    }

    return dp(n: amount)
}

//回溯法
//背包问题，先找出递归树，优化，使用备忘录，优化递归
func beibao(i: Int, cw: Int) {
    
}

//问题：我们有一个数字序列包含 n 个不同的数字，如何求出这个序列中的最长递增子序列长度？比如 2, 9, 3, 6, 5, 1, 7 这样一组数字序列，它的最长递增子序列就是 2, 3, 5, 7，所以最长递增子序列的长度是 4。
//解法：动态规划，贪心
//回溯
func findLongestArr(_ items: [Int]) -> [Int] {
    //base
    if items.count == 0 { return [] }
    if items.count == 1 { return items }
    
    var res: [Int] = []
    
    return res
}

//动态规划

func findNumberOfLIS(_ nums: [Int]) -> Int {
    //两个状态（n: 存储的个数, ） 状态转移方程: f(n) = f
    if nums.count <= 1 { return nums.count }
    var dp: [Int] = Array(repeating: 1, count: n + 1)
    var maxLength =
    dp[0] = 0
    
    for i in 0...dp.count {
        for j in i...dp.count
            if
            dp[i] = Swift.max(dp[i], 1 + dp[i - j])
        }
    }
    return dp[n]
}

//贪心

//对比
//1.动态规划记录了整个状态渐变过程，所以能快速得出最优解，还能反推出最优解的实际方案

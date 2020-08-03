//: A UIKit based Playground for presenting user interface

import UIKit

//分治：分而治之，拆分为不重复子问题，子问题求解，合并结果（合并函数是关键，直接影响分治的效率)，分治解决思路是自下向上解决合并问题
//要求：子问题不重复，有最小解
//实际应用：归并排序，快排算吗？
//问题1：求出数组的有序或逆序对个数, 有序和逆序解决思路相似
//思路：数组分成n1 + n2, n1的逆序个数k1, n2的逆序个数 k2, n1和n2之间的逆序个数k3，结果 = k1 + k2 + k3。 分解成最小单位，再次合并的时候统计结果，
func reversePairs(_ nums: [Int]) -> Int {
    guard nums.count > 1 else { return 0 }
    var result = 0
    
    //分解
    func mergeSort2(arr: [Int]) -> [Int] {
        guard arr.count > 1 else { return arr }
        let mid = arr.count >> 1
        let larr = mergeSort2(arr: Array(arr[0..<mid]))
        let rarr = mergeSort2(arr: Array(arr[mid..<arr.count]))
        return merge(leftArr: larr, rightArr: rarr)
    }
    
    //合并
    func merge(leftArr: [Int], rightArr: [Int]) -> [Int] {
        var i = 0
        var j = 0
        var resultArr: [Int] = []
        
        while i < leftArr.count && j < rightArr.count {
            if leftArr[i] <= rightArr[j] {
                resultArr.append(leftArr[i])
                i += 1
            } else {
                //记录逆序对，当右数组元素大于左数组元素, 左边中剩下都是逆序对的
                result += leftArr.count - i
                resultArr.append(rightArr[j])
                j += 1
            }
        }
        
        while i < leftArr.count {
            resultArr.append(leftArr[i])
            i += 1
        }
        
        while j < rightArr.count {
            resultArr.append(rightArr[j])
            j += 1
        }
        return resultArr
    }
    
    _ = mergeSort2(arr: nums)
    
    return result
}

//问题2：二维平面上有 n 个点，如何快速计算出两个距离最近的点对
//思路: 将二维根据x轴平分为d1,d2区域，d1中最短的线和d2中最短的线，再与d1点和d2点构成的最短线做对比
//https://blog.csdn.net/qq_34732729/article/details/99866969

//问题3：有两个 n*n 的矩阵 A，B，如何快速求解两个矩阵的乘积 C=A*B
//思路：分治

//分治在处理海量数据的应用
//google的大数据应用：maoReduce
//分治的思考：分治解决的是超大量级解决问题的方式，可以用来做时间和空间之间的互相转换，但是注意分治是提升了并发解决问题的时间，但是合并函数的复杂度和鲁棒性直接决定了问题的解决质量，所以分治是种有限解决方案

//回溯
//问题：八皇后
//最终结果存储的列数,行数自然是由0-7

//letcode：八皇后， n皇后
class Solution {
    private var strResult: [[String]] = []
    private var colsResult: [Int] = []
    private var max = 0
    func solveNQueens(_ n: Int) -> [[String]] {
        if n == 0 { return [] }
        if n == 1 { return [["Q"]] }
        max = n
        colsResult = Array(repeating: 0, count: max)
        callQueue(0)
        return strResult
    }

    func callQueue(_ row: Int) {
        if row == max {
            strResult = outPutResult()
            return
        }

        for i in 0...max - 1 {
            if isOk(row, i) {
                colsResult[row] = i
                callQueue(row + 1)
            }
        }
    }

    func isOk(_ row: Int, _ col: Int) -> Bool {
        guard row > 0 else {
            return true
        }
        var leftup = col - 1
        var rightup = col + 1
        for i in (0...(row - 1)).reversed() {
            if colsResult[i] == col {
                return false
            }

            if leftup >= 0 {
                if leftup == colsResult[i] { return false}
            }

            if rightup < max {
                if rightup == colsResult[i] { return false }
            }

            leftup -= 1
            rightup += 1
        }
        return true
    }

    func outPutResult() -> [[String]] {
        let cols = colsResult
        var result: [[String]] = Array(repeating: Array(repeating: "", count: max), count: max)
        for i in 0...max - 1 {
            for j in 0...max - 1 {
                if cols[i] == j {
                    result[i][j] = "Q"
                } else {
                    result[i][j] = "."
                }
            }
        }
        return result
    }
}

//所有解:所谓赋值1，2，3，4，跳过首位继续执行剩下的情况，最后的结果过滤掉空情况

//0 - 1背包问题
var bagMax = Int.min

func getMax(items: [Int], cw: Int, i: Int, w: Int) {
    if cw == w || i == items.count {
        if cw > bagMax {
            bagMax = cw
            return
        }
    }
    getMax(items: items, cw: cw, i: i + 1, w: w)
    if cw + items[i] <= w {
        getMax(items: items, cw: cw + items[i], i: i + 1, w: w)
    }
}
//备忘录优化


//正则表达式

//class Pattern {
//    private var matched = false
//    private var text = ""
//
//    init(text: String) {
//        self.text = text
//    }
//
//    func match(text: String) -> Bool{
//        matched = false
//        rmatch(text: text)
//        return matched
//    }
//
//    private func rmatch(text: String) {
//        var i = 0
//        if matched { return }
//        guard text.count > 0 else { return }
//        if text[i] == "*" {
//            rmatch(text: text[i+1...text.count])
//        } else if text[i] == "?" {
//
//        } else if text[i]  {
//
//        }
//    }
//}

//回溯思考:



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
//思考：如果需要找出最有解的实际执行方案就需要记录所有的状态，这时候得用状态表
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
    if value == (3 * w + 1) { return } //无解
    for i in 1...n-1 {
        if value - items[i] >= 0 && statesMap[i - 1][value - items[i]] {
            print("\(items[i]) ") //购买
            value = value - items[i]
        }
    }
    if value != 0 { print("\(items[0]) ") }
}

//问题：杨辉三角

var sanjiao: [[Int]] = [[5], [7,8], [2,3,4], [4,9,6,1], [2,7,9,4,5]]
var minPath = Int.max

func getPath(s: [[Int]]) {
    var dp: [[Int]] = []
    dp[0][0] = s[0][0]
    for i in 1...s.count {
        for j in 0...s[i].count {
            if j == 0 {
                dp[i][j] = dp[i - 1][j] + dp[i][j]
            } else if j == s[i].count - 1  {
                dp[i][j] = dp[i - 1][j - 1] + dp[i][j]
            } else {
                dp[i][j] = min(dp[i - 1][j] , dp[i - 1][j - 1]) + dp[i][j]
            }
        }
    }
    for p in dp[dp.count - 1] {
        if dp[dp.count - 1][p] < minPath {
            minPath = dp[dp.count - 1][p]
        }
    }
}

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
//解法：动态规划
//状态: 数组个数n，最大数量max(没构成一个数组和现有值对比), 根据i和后续对比来获取递增数组
//状态表：由数组个数n，和最大值构成？
//状态转移方程: fn = Max(f(n - 1)) + 1 || f(n - 1)

func findLongestArr(_ items: [Int]) -> Int {
    guard items.count > 1 else {
        return items.count
    }
    var dp: [Int] = []
    dp[0] = 1
    
    //状态转移方程
    for i in 0...items.count {
        var max = 0
        for j in i...items.count {
            if items[j] < items[i] {
                if dp[i] > max { max = dp[i]}
            }
        }
        dp[i] = max + 1
    }

    var res = 0
    for i in (0...items.count) {
        if dp[i] > res {
            res = dp[i]
        }
    }
    return res
}

//动态规划

//func findNumberOfLIS(_ nums: [Int]) -> Int {
//    //两个状态（n: 存储的个数, ） 状态转移方程: f(n) = f
//    if nums.count <= 1 { return nums.count }
//    var dp: [Int] = Array(repeating: 1, count: n + 1)
//    var maxLength =
//    dp[0] = 0
//
//    for i in 0...dp.count {
//        for j in i...dp.count
//            if
//            dp[i] = Swift.max(dp[i], 1 + dp[i - j])
//        }
//    }
//    return dp[n]
//}

//贪心

//对比
//1.动态规划记录了整个状态渐变过程，所以能快速得出最优解，还能反推出最优解的实际方案

//贪心
//问题：区间覆盖，分糖果


//-------------------------------------------

class BackProblems {
    //n皇后：回溯
    func nQueues(n: Int) -> [[String]] {
        var cols: [Int] = []
        var res: [[String]] = []
        
        //n...n
        func callQueue(row: Int) {
            if row == n {
                getQueuesResult()
                return
            }
            
            for j in 0...n - 1 {
                if isOK(row: row, col: j) {
                    cols[row] = j
                    callQueue(row: row + 1)
                }
            }
        }
        
        func isOK(row: Int, col: Int) -> Bool {
            guard row > 0 else {
                return true
            }
            var leftup = col - 1
            var rightup = col + 1
            for i in (0...(row - 1)).reversed() {
                if cols[i] == col {
                    return false
                }
                
                if leftup >= 0 {
                    if leftup == cols[i] {
                        return false
                    }
                }
                
                if rightup < 0 {
                    if rightup == cols[i] {
                        return false
                    }
                }
                
                leftup -= 1
                rightup += 1
            }
            return true
        }
        
        func getQueuesResult() {
            var result: [[String]] = Array(repeating: Array(repeating: "", count: n), count: n)
            for i in 0...n - 1 {
                for j in 0...n - 1 {
                    if cols[i] == j {
                        result[i][j] = "Q"
                    } else {
                        result[i][j] = "."
                    }
                }
            }
            res = result
        }
        
        callQueue(row: 0)
        return res
    }

    //0-1 背包：回溯解及其优化, 升级问题
    var bagMax2 = Int.min
    
    func getBagMax(items: [Int], cw: Int, w: Int, i: Int) {
        if w == cw || i == items.count {
            if w > bagMax2 {
                bagMax2 = w
                return
            }
        }
        
        //不选
        getBagMax(items: items, cw: cw, w: w, i: i + 1)
        
        //选
        if (w + items[i]) <= cw {
            getBagMax(items: items, cw: cw, w: w + items[i], i: i + 1)
        }
    }

    //优化: 备忘录
    var cw: Int = 0
    var w = 0
    var i = 0
    var mem: [[Bool]] = []
    func setup(items: [Int], cw: Int) {
        self.cw = cw
        mem = Array(repeating: Array(repeating: false, count: items.count), count: cw)
        getBagMaxWitMem(items: items)
    }
    
    func getBagMaxWitMem(items: [Int]) {
        if w == cw || i == items.count {
            if w > bagMax2 {
                bagMax2 = w
                return
            }
        }
        //避免重复计算
        if mem[w][i] { return }
        mem[w][i] = true
        
        //不选
        getBagMax(items: items, cw: cw, w: w, i: i + 1)
        
        //选
        if (w + items[i]) <= cw {
            getBagMax(items: items, cw: cw, w: w + items[i], i: i + 1)
        }
    }
}

class MergeProlbems {
    //求逆序对: 归并
    //逆序对的结果是两两对比的，如果能知道单个数组元素和另一个有序数组元素的大小对比，就能直接得出和剩下元素的逆序,归并排序符合拆成最小逻辑并两两对比的需要，只需要记录逆序对的个数
    //归并函数： 拆分，合并（合并函数是核心，直接决定复杂度和性能）
    func findReveredPair(numbers: [Int]) -> Int {
        var res = 0
        func mergeSort(numbers: [Int]) -> [Int] {
            let mid = numbers.count >> 1
            let left = mergeSort(numbers: Array(numbers[0...mid]))
            let right = mergeSort(numbers: Array(numbers[(mid + 1)...numbers.count]))
            return merge(left: left, right: right)
        }
        
        //对比逻辑在合并函数中
        func merge(left: [Int], right: [Int]) -> [Int] {
            var i = 0
            var j = 0
            var result: [Int] = []
            while i < left.count && j < right.count {
                if left[i] > right[j] {
                    result.append(right[j])
                    j += 1
                    res += right.count - i
                } else {
                    result.append(left[i])
                    i += 1
                }
            }
            
            while i < left.count {
                result.append(left[i])
                i += 1
            }
            
            while j < right.count {
                result.append(right[j])
                j += 1
            }
            return result
        }
        
        mergeSort(numbers: numbers)
        
        return res
    }
    
    //我想做的
    //涂色问题
}

class DynamicProblems {
    //0-1 背包
    //动态表
    func getBagMax(items: [Int], cw: Int) -> Int {
        
    }
    
    //动态转移方程
    func getBagMaxWithFn(items: [Int], cw: Int) -> Int {
        
    }
}

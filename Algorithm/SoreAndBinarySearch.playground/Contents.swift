//: A UIKit based Playground for presenting user interface

class Sort {
    
    //基本排序： O（n2)
    func bubbleSort(_ nums: inout [Int]) {
        //不稳定，出现前后重复交换
        for i in 0...nums.count - 1 {
            var flag = false
            for j in 0...nums.count - i - 1 {
                if nums[j] > nums[j + 1] {
                    nums.swapAt(j, j + 1)
                    flag = true
                }
            }
            if !flag { break }
        }
    }
    
    func insertSort(_ nums: [Int]) -> [Int] {
        var result: [Int] = nums
        for i in 0...nums.count - 1 {
            let val = nums[i]
            var j = i - 1
            for _ in (0...i - 1).reversed() {
                if nums[j] > val{
                    result[j + 1] = result[j]
                } else {
                    break
                }
                j -= 1
            }
            result[j + 1] = val
        }
        return result
    }
    
    func selectSort(_ nums: inout [Int]) {
        for i in 0...nums.count - 1 {
            var minIndex = i
            for j in i + 1...nums.count - 1 {
                if nums[j] > nums[minIndex] {
                    minIndex = j
                }
            }
            if minIndex != i {
                nums.swapAt(i, minIndex)
            }
        }
    }
    
    //升级排序：归并排序，桶排序，快速排序
    //合并：从下往上排序, 核心是合并函数
    func mergeSort(_ nums: [Int]) -> [Int] {
        guard nums.count > 0 else {
            return []
        }
        //合并函数
        func mergeTwoArray(_ arr1: [Int], _ arr2: [Int]) -> [Int] {
            var left = 0
            var right = 0
            var result: [Int] = []
            while left < arr1.count && right < arr2.count {
                if arr1[left] > arr2[right] {
                    result.append(arr2[right])
                    right += 1
                } else {
                    result.append(arr1[left])
                    left += 1
                }
            }
            
            if left < arr1.count {
                result.append(contentsOf: arr1[left..<arr1.count])
            }
            
            if right < arr2.count {
                result.append(contentsOf: arr2[right..<arr2.count])
            }
            return result
        }
        
        //拆分
        let mid = nums.count / 2
        let left = mergeSort(Array(nums[0...(mid-1)]))
        let right = mergeSort(Array(nums[mid..<nums.count]))
        //合并
    
        return mergeTwoArray(left, right)
    }
    
    //快排：从上往下排序, 核心是找partion位置的函数，
    func quickSort(_ nums: inout [Int]) {
        func partition2(_ nums: inout [Int]) -> Int {
            let high = nums.count - 1
            let p = nums[high]
            var i = 0
            for j in 0..<nums.count {
                if nums[j] <= p {
                    nums.swapAt(i, j)
                    i += 1
                }
            }
            
            nums.swapAt(i, nums[high])
            return i
        }
        
        func partition(_ nums: inout [Int]) -> Int {
            let pivot = nums.last ?? 0
            var i = 0
            for j in 0..<nums.count {
                if nums[j] < pivot {
                    nums.swapAt(i, j)
                    i += 1
                }
            }
            nums.swapAt(i, nums.count - 1)
            return i
        }
        //伪代码： result = quicksort(0...pivot) + quicksort(pivot + 1...count)
        let pivot = partition(&nums)
//        quickSort(nums[0...(pivot - 1)])
//        quickSort(nums[(pivot + 1)..<nums.count])
    }
    
    
    //高级特定场景优化排序：计数排序
}

class BinarySearch {
    //有序O(logn)查找
    func binarySearch(_ nums: [Int], _ target: Int) -> Int {
        guard nums.count > 0 else {
            return -1
        }
        var left = 0
        var right = nums.count - 1
        var mid = nums.count / 2
        while left <= right {
            mid = (right - left) / 2 + left
            if nums[mid] == target {
                return mid
            } else if nums[mid] > target {
                right = mid - 1
            } else {
                left = mid + 1
            }
        }
        return mid
    }
    
    //第一个或最后一个
    
    func binarySearchFirst(_ nums: [Int], _ target: Int) -> Int {
        guard nums.count > 0 else {
            return -1
        }
        var left = 0
        var right = nums.count - 1 //这里是闭区间
        var mid = nums.count / 2
        while left <= right {
            mid = (right - left) / 2 + left
            if nums[mid] >= target {
                right = mid - 1
            } else {
                left = mid + 1
            }
        }
        
        //因为是闭区间需要考虑越界
        if right < 0 || nums[right] != target { return -1 }
        return right
    }
}

class Solution {
    //编程实现 O(n) 时间复杂度内找到一组数据的第 K 大元素
    //思路：使用partytion函数确定k元素
    //
    func findK(_ nums: inout [Int], k: Int) -> Int {
        guard k <= nums.count - 1 else {
            return -1
        }
        var result = -1
        let p = partition2(&nums)
        if p + 1 == k {
            result = p + 1
        } else if p < k  {
//            result = findK(nums[(p+1)..<nums.count], k: 2k - p)
        } else {
//            result = findK(nums[0...(p - 1)], k: p - k)
        }
        return nums[result]
    }
    
    func partition2(_ nums: inout [Int]) -> Int {
        let high = nums.count - 1
        let p = nums[high]
        var i = 0
        for j in 0..<nums.count {
            if nums[j] <= p {
                nums.swapAt(i, j)
                i += 1
            }
        }
        
        nums.swapAt(i, nums[high])
        return i
    }
    
    func mySqrt(_ x: Int) -> Int {
        var left = 0
        var right = x / 2 + 1
        while left < right {
            let m = (left + right + 1) >> 1
            if m * m > x {
                right = m - 1
            } else {
                left = m
            }
        }
        return left
    }
}

//var arr = [1, 2, 3]
//arr.reduce("") { (result, cur) -> String in
//    return result + "\(cur)"
//}
//
//var set: Set<String> = [] //去重
//set.insert(<#T##newMember: String##String#>)

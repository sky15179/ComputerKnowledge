//
//  ViewController.swift
//  LearnAl
//
//  Created by 王智刚 on 2020/7/27.
//  Copyright © 2020 王智刚. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print(Solution().reversePairs([7,5,6,4]))
    }
}


class Solution {
    func reversePairs(_ nums: [Int]) -> Int {
        guard nums.count > 1 else { return 0 }
        var result = 0
        
        //分解
        func mergeSort2(arr: [Int]) -> [Int] {
            guard arr.count > 1 else { return arr }
            let mid = arr.count / 2
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
}

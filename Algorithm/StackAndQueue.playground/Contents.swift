//: A UIKit based Playground for presenting user interface
  
import UIKit

//栈

//队列， 循环队列，阻塞队列，并发队列，优先队列
//循环队列
class MyCircularQueue {

    /** Initialize your data structure here. Set the size of the queue to be k. */
    init(_ k: Int) {
        
    }
    
    /** Insert an element into the circular queue. Return true if the operation is successful. */
    func enQueue(_ value: Int) -> Bool {
        
    }
    
    /** Delete an element from the circular queue. Return true if the operation is successful. */
    func deQueue() -> Bool {
        
    }
    
    /** Get the front item from the queue. */
    func Front() -> Int {
        
    }
    
    /** Get the last item from the queue. */
    func Rear() -> Int {
        
    }
    
    /** Checks whether the circular queue is empty or not. */
    func isEmpty() -> Bool {
        
    }
    
    /** Checks whether the circular queue is full or not. */
    func isFull() -> Bool {
        
    }
}

/**
 * Your MyCircularQueue object will be instantiated and called as such:
 * let obj = MyCircularQueue(k)
 * let ret_1: Bool = obj.enQueue(value)
 * let ret_2: Bool = obj.deQueue()
 * let ret_3: Int = obj.Front()
 * let ret_4: Int = obj.Rear()
 * let ret_5: Bool = obj.isEmpty()
 * let ret_6: Bool = obj.isFull()
 */

//阻塞队列

//并发队列

//优先队列
class PriorityQueue {
    //最大堆
//    var heap
}

//数组，循环列表

//堆: 最大堆，最小堆, 核心是完全二叉树和中序遍历顺序数组
class Heap {
    private var arr: [Int] = []
    private var count = 0
    private var capacity = 0
    
    init(capacity: Int) {
        self.capacity = capacity
        arr = Array(repeating: 0, count: capacity)
    }
    
    //插入：插入到数组尾部然后向前不断替换
    func insert(data: Int) {
        if count >= capacity { return }
        count += 1
        var i = count
        arr[count] = data
        while i / 2 > 0 && arr[i] > arr[i / 2] { //和父节点交换
            (arr[i], arr[i / 2]) = (arr[i / 2], arr[i])
            i = i / 2
        }
    }
    
    convenience init(arr: [Int]) {
        self.init(capacity: arr.count)
        self.arr = arr
        let nums = 1...(arr.count/2)
        for i in nums.reversed() {
            heapify(n: arr.count, i: i)
        }
    }
    
    //删除：将最后的节点与根节点替换，然后再对根节点进行大小置换
    func removeMax() {
        if count == 0 { return }
        arr[1] = arr[count]
        count -= 1
        heapify(n: count, i: 1)
    }
    
    private func heapify(n: Int, i: Int) {
        var number = i
        while true {
            var max = i
            if number * 2 <= n && arr[number] < arr[number*2] { max = number * 2 }
            if number * 2 + 1 <= n && arr[max] < arr[number*2 + 1] { max = number * 2 + 1 }
            if max == number { break }
            (arr[number], arr[max]) = (arr[max], arr[number])
            number = max
        }
    }
    
    func sort(arr: [Int]) {
        self.arr = arr
        var n = arr.count
        while n > 1 {
            (self.arr[1], self.arr[n]) = (self.arr[n], self.arr[1])
            n -= 1
            heapify(n: n, i: 1)
        }
    }
}

//图: 邻接表，邻接矩阵
//图的一些操作：

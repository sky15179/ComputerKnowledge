//: A UIKit based Playground for presenting user interface
  
import UIKit

//栈

//队列， 循环队列，阻塞队列，并发队列，优先队列
//循环队列
class MyCircularQueue {
    private var arr: [Int]
    private var front = 0
    private var rear = 0
    private var capacity: Int = 0

    /** Initialize your data structure here. Set the size of the queue to be k. */
    init(_ k: Int) {
        arr = Array(repeating: 0, count: k)
        capacity = k
    }
    
    /** Insert an element into the circular queue. Return true if the operation is successful. */
    func enQueue(_ value: Int) -> Bool {
        if isFull() { return false }
        arr[rear] = value
        rear = (rear + 1) % capacity
        return true
    }
    
    /** Delete an element from the circular queue. Return true if the operation is successful. */
    func deQueue() -> Bool {
        if isEmpty() { return false }
        arr[front] = 0
        front = (front + 1) % capacity
        return true
    }
    
    /** Get the front item from the queue. */
    func Front() -> Int {
        return arr[self.front]
    }
    
    /** Get the last item from the queue. */
    func Rear() -> Int {
        return self.arr[self.rear]
    }
    
    /** Checks whether the circular queue is empty or not. */
    func isEmpty() -> Bool {
       return front == rear
    }
    
    /** Checks whether the circular queue is full or not. */
    func isFull() -> Bool {
        return (rear + 1 ) % capacity == self.front
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

class PriorityQueue<T> {
    var list: [T] = []
    
    func enqueue(_ val: T) {
        shiftUp()
    }
    
    func dequeue() -> T? {
        shiftDown()
        return nil
    }
    
    func compare(l: T, r: T) -> Int {
        return 1
    }
    
    private func shiftUp() {
        
    }
    
    private func shiftDown() {
        
    }
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

//栈实现浏览器

class Browser {
    
    private let forwardStack = Stack1()
    private let backStack = Stack1()
    
    init() {}
    
    func push(val: Int) {
        backStack.push(val)
    }
    
    func back() {
        if backStack.isEmpty() {
            print("最后一页")
        }
        if let val = backStack.pop() {
            forwardStack.push(val)
            print("前进\(val)")
        } else {
            print("前进失败")
        }

    }
    
    func forward() {
        if forwardStack.isEmpty() {
            print("最后一页")
        }
        if let val = forwardStack.pop() {
            backStack.push(val)
            print("前进\(val)")
        } else {
            print("前进失败")
        }
    }
}

//顺序栈，链栈：本质就是线性表上加上约束操作，表面暴露出来的就是ADT的约束方法
//链表的核心约束操作依赖于他的核心特性先进后出FIFO：栈顶的push和pop操作
//差异在于：操作的效率和内存构成上的差异（就是链表和数组的差异），数组需要扩容设计，链表占用更多内存

protocol StackAble {
    func push(_ value: Int)
    func pop() -> Int?
    func peek() -> Int?
    func isEmpty() -> Bool
}

//顺序
class Stack1: StackAble {
    private var arr: [Int] = []
    init() {
        
    }
    
    func push(_ value: Int) {
        //这里可能涉及到动态扩容
        arr.append(value)
    }
    
    func pop() -> Int? {
        arr.popLast()
    }

    func peek() -> Int? {
        return arr[0]
    }
    
    func isEmpty() -> Bool {
        return arr.count == 0
    }
}

//链
class Stack2: StackAble {
    func peek() -> Int? {
        return link.head?.value
    }
    
    func isEmpty() -> Bool {
        return link.head == nil
    }
    
    private var link: LinkList
    
    init() {
        link = LinkList()
    }
    
    func push(_ value: Int) {
        link.insert(value)
    }
    
    func pop() -> Int? {
        let res = link.tail
        if let res = res {
            link.remove(res)
        }
        return res?.value
    }
}

//线性表ADT: 增删改查， 头尾
protocol SequenceAble {
    associatedtype Node
    
    var head: Node? { get }
    var tail: Node? { get }
    var isEmpty: Bool { get }
    
    func insert(_ val: Int)
    func remove(_ node: Node)
    func get(_ val: Int) -> Node?
}

class LinkList: SequenceAble {
    func remove(_ node: LinkList.Node) {
        
    }
    
    var isEmpty: Bool {
        return head == nil
    }
    
    var head: Node?
    var tail: Node?
    var size = 0
    
    class Node {
        var value: Int
        var next: Node?
        
        init(_ value: Int) {
            self.value = value
        }
    }
    
    init() {
        
    }
    
    func insert(_ val: Int) {
        let node = Node(val)
        if head == nil {
            head = node
        } else {
            head?.next = node
        }
        tail = node
        size += 1
    }
    
    func removeLast() {
        
    }
    
    func get(_ val: Int) -> Node? {
        return nil
    }
}

protocol QueueAble {
    func enqueue(_ val: Int)
    func dequeue() -> Int?
    var isEmpty: Bool { get }
}

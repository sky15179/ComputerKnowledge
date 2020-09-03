class MyString {
    //朴素匹配：可优化，使用hash函数求子串值, 二次遍历直接比对hash值
    func simple() {
        
    }
    
    func kmp() {
        
    }
    
    func bm() {
        
    }
}

class HashMapNode {
    private var linkList: LinkList = LinkList()
    private var key: Int
    init(key: Int, val: Int) {
        self.key = key
    }
    
    func insert(key: Int, val: Int) {
        self.linkList.insert(val, key)
    }
    
    func get() -> Int? {
        let num = self.linkList.tail?.value
        if let tail = self.linkList.tail {
            self.linkList.remove(tail)
        }
        return num
    }
}

//注意事项，大小扩容和hash设计是hashMap的设计难点
//设计的主要大函数扩容：resize, 数组复制时有大容量优化方法：分开分次复制，避免一次全量复制
//ADT
/**
map {
    class node {
        pre: node?
        next: node?
        val: Int
        key: Int
    }
    
    private use: Int //数组使用的index个数
    private size: Int //所有元素的个数
    private expland: Int (0~1)
    private nodes: [Node]
    
    func put(key: Int, val: Int) {} //注意：新建node时可以使用委托节点来处理节点的新增避免特殊情况
    func get(key) {} //根据index找出node链表，在链表上迭代找出key == key的条件
    func remove(key)
    func getLength() -> Int //使用到的元素index，为了做扩容计算
    private func resize() //扩容: 数组的复制
    private func hash() -> Int //简单hash函数，key % nodes.count
}
**/

extension Array {
    func safeGet(_ index: Int) -> Element? {
        if index >= self.count {
            return nil
        } else {
            return self[index]
        }
    }
}

class HashMap {
    private class Node {
        var pre: Node?
        var next: Node?
        var key: Int
        var val: Int
        
        init(_ key: Int,_ val: Int) {
            self.key = key
            self.val = val
        }
    }
    private var nodes: [Node] = []
    private var use = 0
    private var size = 0
    private let expand = 0.75
    
    init() {
        nodes = Array(repeating: Node(-1, -1), count: 10)
    }
    
    func put(_ key: Int, _ value: Int) {
       //委托节点处理链表新增节点
        let index = hash(key: key)
        let newNode = Node(key, value)
        
        if let node = nodes.safeGet(index)?.next {
            var cur: Node? = node
            while cur != nil {
                cur = cur?.next
                if let nkey = cur?.key, nkey == key {
                    cur?.val = value
                    return
                }
            }
            let temp = nodes.safeGet(index)?.next
            newNode.next = temp
            nodes[index].next = newNode
            size += 1
        } else { //新增index的node
            let dummyNode = Node(-1, -1)
            nodes[index] = dummyNode
            nodes.safeGet(index)?.next = newNode //链表使用头插
            size += 1
            use += 1
            
            if use > Int(Double(nodes.count) * expand) {
                resize()
            }
        }
    }
    
    func get(_ key: Int) -> Int? {
        let index = hash(key: key)
        if let node = nodes.safeGet(index) {
            var cur: Node? = node
            while cur?.next != nil && cur != nil {
                if node.key == key {
                    return cur?.val
                } else {
                    cur = cur?.next
                }
            }
        }
        return nil
    }
    
    func remove(_ key: Int) {
        let index = hash(key: key)
        if let node = nodes.safeGet(index) {
            var cur: Node? = node
            var pre: Node? = nil
            while cur?.next != nil && cur != nil {
                if node.key == key {
                    pre?.next = cur?.next
                    size -= 1
                    return
                } else {
                    pre = cur
                    cur = cur?.next
                }
            }
        }
    }
    
    func getLength() -> Int {
        return use
    }
    
    //核心，冲突概率，性能瓶颈
    private func hash(key: Int) -> Int {
        return key % nodes.count
    }
    
    //核心，性能瓶颈（大容量数组复制）
    private func resize() {
        //遍历，复制
        use = 0
        let newNodes = Array(repeating: Node(-1, -1), count: self.nodes.count * 2)
        for (index, node) in self.nodes.enumerated() {
            var cur: Node? = node
            while cur?.next != nil {
                let next = newNodes[index].next
                if let key = next?.key, let val = next?.val {
                    let temp = newNodes[index].next
                    let newNode = Node(key, val)
                    newNode.next = temp
                    newNodes[index].next = newNode
                    use += 1
                }
                cur = cur?.next
            }
        }
        self.nodes = newNodes
    }
}

//LRU: 最近缓存
class LRU {
    private var map: [Int: LinkList.Node] = [:]
    private let doubleLink: LinkList = LinkList() //控制长度和保持优先级排列
    private let capacity: Int
    
    init(capacity: Int) {
        self.capacity = capacity
    }
    
    //增加，查找, 删除
    //O（1）时间完成元素查找操作：hashmap
    //O（1）时间完成获取最近元素的操作：链表取Head，需要做元素删除为了，为了删除性能使用双向链表
    func insert(key: Int, val: Int) {
        //尾插，头取, size处理
        if doubleLink.size > self.capacity, let head = self.doubleLink.head  {
            self.map.removeValue(forKey: head.key)
            self.doubleLink.remove(head)
        }
        if let node = map[key] {
            doubleLink.remove(node)
        }
        doubleLink.insert(val, key)
    }
    
    func getLastest() -> Int? {
       return doubleLink.tail?.value
    }
    
    func get(key: Int) -> Int? {
        guard let node = map[key] else { return nil }
        self.doubleLink.remove(node)
        self.insert(key: key, val: node.value)
        return node.value
    }
    
    func remove(key: Int) -> Int? {
        guard let node = map[key] else { return nil }
        let num = node.value
        doubleLink.remove(node)
        return num
    }
}


class LinkList {
    func remove(_ node: LinkList.Node) {
        if tail === node {
            tail = node
            tail?.next = nil
        }
        if head === node {
            head = node
        }
        let pre = node.pre
        let next = node.next
        pre?.next = next
        next?.pre = pre
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
        var key: Int
        var pre: Node?
        
        init(_ value: Int, _ key: Int) {
            self.value = value
            self.key = key
        }
    }
    
    init() {
        
    }
    
    func insert(_ val: Int,_ key: Int) {
        let node = Node(val, key)
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

let arr = [1,2,3]
arr.enumerated()

// Subscript
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


class Solution {
    private var target = ""
//    private var visited: Set<Position> = Set()
    private var maxLength = 0
    private var strs: [String] = []

    //矩阵搜索: dfs
    func exist(_ board: [[Character]], _ word: String) -> Bool {
        guard board.count > 0, word.count > 0 else { return false }
        maxLength = word.count - 1
        target = word
        for c in word {
            strs.append(String(c))
        }
        var board2 = board
        self.target = word
        for i in 0..<board.count {
            for j in 0..<board[0].count {
                if helper(&board2, i, j, 0) { return true }
            }
        }
        return false
    }

    func helper(_ board: inout [[Character]], _ i: Int, _ j: Int, _ k: Int) -> Bool {
        //退出条件
        if i >= board.count || i < 0 { return false }
        if j >= board[0].count || j < 0 { return false }
        if String(board[i][j]) != strs[k] { return false }
        if k == maxLength { return true }

        //选择后需要对当前位置占位避免重复
        let temp = board[i][j]
        board[i][j] = "/"


                //四种变化
        //        i + 1
        //        i - 1
        //        j + 1
        //        j - 1
        let res = helper(&board, i + 1, j, k + 1) || helper(&board, i - 1, j, k + 1) || helper(&board, i, j + 1, k + 1) || helper(&board, i, j - 1, k + 1)
        
        //恢复选择
        board[i][j] = temp
        return res
    }
}

//表格搜索问题: 基本都是dfs和bfs或者回溯思路解决

class Solution2 {
    private class Position: Equatable, Hashable {
        static func == (lhs: Solution2.Position, rhs: Solution2.Position) -> Bool {
            return lhs.x == rhs.x && lhs.y == rhs.y
        }
        
        var x: Int
        var y: Int
        
        init(x: Int, y: Int) {
            self.x = x
            self.y = y
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(hashValue)
        }
        
        var hashValue: Int {
            return x * 10 + y
        }
    }
    
    private var maxSum = 0
    private var m = 0
    private var n = 0
    private var k = 0
    private var visited: [Position: Bool] = [:]
    private var visited3: [[Bool]] = []
    
    func movingCount(_ m: Int, _ n: Int, _ k: Int) -> Int {
        guard m > 0, n > 0 else {
            return 0
        }
        guard k > 0 else {
            return 1
        }
        
        var res = 0
        var visited2: [[Bool]] = Array(repeating: Array(repeating: false, count: n), count: m)
        var queue: [[Int]] = []
        queue.append([0, 0, 0, 0])
        while !queue.isEmpty {
            let first = queue.removeFirst()
            let i = first[0]
            let j = first[1]
            let si = first[2]
            let sj = first[3]
            if (i >= m) || ( j >= n) || (k < si + sj) || visited2[i][j] { continue }
            visited2[i][j] = true
            res += 1
            queue.append([i + 1, j, calculateSum(si + 1), sj])
            queue.append([i, j + 1, si, calculateSum(sj + 1)])
        }
        return res
    }
    
    func movingCount2(_ m: Int, _ n: Int, _ k: Int) -> Int {
        guard m > 0, n > 0 else {
            return 0
        }
        guard k > 0 else {
            return 1
        }

        var queue: [[Int]] = []
        queue.append([0, 0, 0, 0])
        
        for i in 0...m {
            for j in 0...n {
                backTrace(i, j)
            }
        }
        //分析：求所有可行解，图的遍历: dfs, bfs
        //设计：i：横步， j: 纵步
        //条件： (i > 0 && i < m , j < 0 && j < n), (i + j <= k)
        //状态变化： (i - 1, 1 + 1 , j - 1, j + 1), ([i][j] = done)
        let res = visited.values.filter { $0 == true }
        return res.count
    }


    func backTrace(_ i: Int, _ j: Int) {
        if visited.keys.contains(Position(x: i, y: j)) { return }
        if i < 0 || i > m - 1 { return }
        if j < 0 || j > n - 1 { return }
        
        //选择，状态变化，记录
        visited[Position(x: i, y: j)] = (calculateSum(i) + calculateSum(j)) > k
        
        backTrace(i + 1, j)
        backTrace(i, j + 1)
    }
    
    func calculateSum(_ i: Int) -> Int {
        var s = 0
        var cur = i
        
        while cur != 0 {
            s += cur % 10
            cur = cur / 10
        }
        return s
    }
    
    func movingCount3(_ m: Int, _ n: Int, _ k: Int) -> Int {
        visited3 = Array(repeating: Array(repeating: false, count: n), count: m)
        self.m = m
        self.n = n
        self.k = k
        let res = dfs(0, 0, 0, 0)
        return res
    }
    
    
    func dfs(_ i: Int, _ j: Int, _ si: Int, _ sj: Int) -> Int {
        if i >= m || j >= n || ((si + sj) >= k) || visited3[i][j] { return 0 }
        visited3[i][j] = true
        return 1 + dfs(i + 1, j, (i + 1) % 10 != 0 ? (si + 1) : (si - 8), sj) + dfs(i, j + 1, si, (j + 1) % 10 != 0 ? (sj + 1) : (sj - 8))
    }
}

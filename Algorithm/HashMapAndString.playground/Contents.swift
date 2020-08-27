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

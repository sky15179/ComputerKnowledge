class MyString {
    
}

class HashMap {
    private var linkList: LinkList
    
    init() {
        linkList = LinkList()
    }
    
    private func hash(val: Int) -> Int {
        return 0
    }
    
    //核心方法：增加，查找，删除
    func add(key: Int, val: Int) {
        
    }
    
    func find(key: Int) -> Int {
        return 0
    }
    
    func remove(key: Int) {
        
    }
}

//LRU: 最近缓存
class LRU {
    private let map: [Int: Int] = [:]
    private let doubleLink: LinkList = LinkList()
    //增加，查找, 删除
    //O（1）时间完成元素查找操作：hashmap
    //O（1）时间完成获取最近元素的操作：链表取Head，需要做元素删除为了，为了删除性能使用双向链表
    func insert(key: Int, val: Int) {
        
    }
    
    func getLastest() -> Int {
        return 0
    }
    
    func get(key: Int) -> Int {
        return 0
    }
    
    func remove(key: Int) -> Int {
        return 0
    }
}


class LinkList {
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

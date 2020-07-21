//: A UIKit based Playground for presenting user interface

import UIKit

class LRUCache {
    class DoubleList<T> {
        class Node<T> {
            var key: Int
            var val: T?
            var prev: Node<T>?
            var next: Node<T>?
            
            init(_ key: Int, val: T?) {
                self.key = key
                self.val = val
            }
        }
        
        var size  = 0
        var head: Node<T>?
        var tail: Node<T>?
        
        init() {
            self.size = 0
            self.head = Node<T>(0, val: nil)
            self.tail = Node<T>(0, val: nil)
            head?.next = tail
            tail?.prev = head
        }
        
        func addFirstNode(_ node: Node<T>) {
            node.next = head?.next
            node.prev = head
            head?.next?.prev = node
            head?.next = node
            size += 1
        }
        
        func remove(_ node: Node<T>) {
            node.prev?.next = node.next
            node.next?.prev = node.prev
            size -= 1
        }
        
        @discardableResult func removeLast() -> Node<T>? {
            if head === tail { return nil }
            if let last = tail?.prev {
                remove(last)
                return last
            } else {
                return nil
            }
        }
    }
    
    var cache: DoubleList<Int> = DoubleList()
    var map: [Int: DoubleList<Int>.Node<Int>] = [:]
    var cap: Int
    
    init(_ capacity: Int) {
        self.cap = capacity
    }
    
    func get(_ key: Int) -> Int {
        guard self.map.keys.contains(key), let val = map[key]?.val else { return -1 }
        put(key, val)
        return val
    }
    
    func put(_ key: Int, _ value: Int) {
        let new = DoubleList<Int>.Node<Int>(key, val: value)
        if map.keys.contains(key) {
            if let old = map[key] {
                cache.remove(old)
            }
        } else {
            if cap == cache.size {
                if let outKey = cache.removeLast()?.key {
                    map.removeValue(forKey: outKey)
                }
            }
        }
        cache.addFirstNode(new)
        map[key] = new
    }
}

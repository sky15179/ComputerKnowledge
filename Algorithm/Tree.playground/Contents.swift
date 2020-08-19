//: A UIKit based Playground for presenting user interfacec

public class TreeNode {
    public var val: Int
    public var left: TreeNode?
    public var right: TreeNode?
    public init(_ val: Int) {
        self.val = val
        self.left = nil
        self.right = nil
    }
}

protocol TreeAble {
    func insert(_ val: Int)
    func delete(_ val: Int)
    func search(_ node: TreeNode?, _ val: Int) -> TreeNode?
}

protocol TreeEnumerAble {
    func dfs(handler: (TreeNode?) -> Void)
    func bfs(handler: (TreeNode?) -> Void)
}

class Tree {
    private(set) var root: TreeNode?
    
    init() {
    }
}

//二叉树

class BinaryTree: TreeAble {
    private(set) var root: TreeNode?

    func insert(_ val: Int) {
        guard root != nil else {
            self.root = TreeNode(val)
            return
        }
        
        var node = self.root
        while node != nil {
            if val > node?.val ?? 0 {
                if node?.right == nil {
                    node?.right = TreeNode(val)
                    return
                }
                node = node?.right
            } else {
                if node?.left == nil {
                    node?.left = TreeNode(val)
                    return
                }
                node = node?.left
            }
        }
    }
    
    //解题思路：节点的删除需要从父节点中删除下个节点的指针，所以需要个临时变量来记录父节点，找到目标节点，同时记录着父节点，链式来回就是各种多指针操作
    //删除节点的情况：1.没有子节点，直接从父节点中移除子节点（需要判断是左指针和右指针 pp.left == p）2.有一个节点：直接将子节点的节点赋值给父节点的子节点即可 3.有两个节点删除后需要对当前子节点之后所有的节点做重新排序（如果节点删除涉及到很复杂的后续整体t移动操作，可以找到将节点替换为根节点的方式，这样就避免了整体树所有节点都发生改变操作）：从右子树中找到最小节点与当前节点互换（更新记录的目标节点和父节点），之后再继续进行2的操作即可
    //特殊情况：root节点是删除节点
    //安全问题:
    func delete(_ val: Int) {
        if root?.val ?? 0 == val {
            root = nil
        }
        //找到目标节点，和删除操作依赖的父节点
        var p = root
        var pre: TreeNode? = nil
        while p != nil && p?.val ?? 0 != val {
            pre = p
            if p?.val ?? 0 > val {
                p = p?.right
            } else if p?.val ?? 0 < val {
                p = p?.left
            }
        }
        
        if p == nil {
            return
        }
        
        //3.有两个节点
        if p?.left != nil && p?.right != nil {
            //右子树找最小节点
            var minp = p?.right
            var minpp = p
            
            while minp?.left != nil {
                minpp = minp
                minp = minp?.left
            }
            
            //节点互换操作
            p?.val = minp?.val ?? 0
            p = minp
            pre = minpp
        }

        //找出删除节点的子节点
        var child: TreeNode? = nil
        if p?.left == nil {
            child = p?.right
        } else if p?.right == nil {
            child = p?.left
        }

        //1.根节点：从父节点中删除节点
        //2.有一个节点：用子节点赋值当前节点
        //从父节点的删除操作
        if pre == nil {
            root = nil
        } else if pre?.left === p {
            pre?.left = child
        } else if pre?.right === p {
            pre?.right = child
        }
        
        //另一种实现：找到节点标记为deleted，使用元素的时候做下判断
    }
    
    func searchByWhile(_ val: Int) -> TreeNode? {
        if let p = root, val == p.val {
            return root
        }
        var p = root
        while p != nil {
            if p?.val ?? 0 < val { p = p?.left }
            else if p?.val ?? 0 > val { p = p?.right }
            else { return p }
        }
        return nil
    }
    
    //递归查找
    func search(_ node: TreeNode?, _ val: Int) -> TreeNode? {
        guard let node = node else { return nil }
        if val > node.val {
            return search(node.right, val)
        } else if val < node.val {
            return search(node.left, val)
        } else {
            return root
        }
    }
}

//MARK: 二叉树常用操作: 现查找二叉查找树中某个节点的后继、前驱节点，实现二叉树前、中、后序以及按层遍历
protocol BinaryTreeAble {
    func findMin(_ node: TreeNode?) -> TreeNode?
    func findMax(_ node: TreeNode?) -> TreeNode?
    func getPreNode(_ node: TreeNode?, _ val: Int) -> TreeNode?
    func getNextNode(_ node: TreeNode?, _ val: Int) -> TreeNode?
}

extension BinaryTreeAble where Self: BinaryTree {
    //辅助方法：查找父节点和最后一个右拐节点
    func getPNode(_ node: TreeNode?, _ val: Int) -> (result: TreeNode?, parent: TreeNode?, firstRightParent: TreeNode?) {
        guard let node = node else {
            return (nil, nil, nil)
        }
        var nNode: TreeNode? = node
        var parent: TreeNode? = nil
        var firstRightParent: TreeNode? = nil
        while nNode != nil {
            if nNode?.val ?? 0 == val {
                return (nNode, parent, firstRightParent)
            }
            parent = nNode
            if val > nNode?.val ?? 0 {
                nNode = nNode?.left
            } else {
                firstRightParent = nNode
                nNode = nNode?.right
            }
        }
        return (nil, nil, nil)
    }
    
    func getNNode(_ node: TreeNode?, _ val: Int) -> (result: TreeNode?, parent: TreeNode?, firstLeftParent: TreeNode?) {
        guard let node = node else {
            return (nil, nil, nil)
        }
        var nNode: TreeNode? = node
        var parent: TreeNode? = nil
        var firstLeftParent: TreeNode? = nil
        while nNode != nil {
            if nNode?.val ?? 0 == val {
                return (nNode, parent, firstLeftParent)
            }
            parent = nNode
            if val > nNode?.val ?? 0 {
                firstLeftParent = nNode
                nNode = nNode?.left
            } else {
                nNode = nNode?.right
            }
        }
        return (nil, nil, nil)
    }
}

extension BinaryTree: BinaryTreeAble {
    func getPreNode(_ node: TreeNode?, _ val: Int) -> TreeNode? {
        guard let node = node else { return nil }
        let (result, parent, firstRightParent) = getPNode(node, val)
        if result == nil { return nil }
        if result?.left != nil {
            return findMax(result?.left)
        }
        
        if parent == nil || (parent != nil && firstRightParent == nil) {
            return nil
        }
        
        if result === parent?.right {
            return parent
        } else {
            return firstRightParent
        }
    }
    
    func getNextNode(_ node: TreeNode?, _ val: Int) -> TreeNode? {
        guard let root = root else { return nil }
        let (result, parent, firstLeftParent) = getNNode(root, val)
        if result == nil { return nil }
        if result?.right != nil {
            return findMin(result?.right)
        }
        if parent == nil || (parent != nil && firstLeftParent == nil) {
            return nil
        }
        
        if result === parent?.left {
            return parent
        } else {
            return firstLeftParent
        }
    }
    
    func findMin(_ node: TreeNode?) -> TreeNode? {
        guard let node = node else { return nil }
        if node.left == nil {
            return root
        } else {
            return findMin(node.left)
        }
    }
    
    func findMax(_ node: TreeNode?) -> TreeNode? {
        guard let node = node else { return nil }
        if node.right == nil {
            return root
        } else {
            return findMax(node.right)
        }
    }
}

//MARK: 二叉树常用操作: dfs，bfs，回溯，解决搜索和

extension BinaryTree {
    //dfs就是中序遍历
    func dfs(node: TreeNode?, handler: (TreeNode?) -> Void) {
        guard let node = node else {
            return
        }
        dfs(node: node.left, handler: handler)
        handler(node)
        dfs(node: node.right, handler: handler)
    }
    
    func bfs(node: TreeNode?, handler: (TreeNode?) -> Void) {
        guard let node = node else {
            return
        }
        var queue: [TreeNode] = []
        queue.append(node)
        
        while !queue.isEmpty {
            let first = queue.removeFirst()
            handler(first)
            if let left = first.left {
                queue.append(left)
            }
            
            if let right = first.right {
                queue.append(right)
            }
        }
    }
}

//MARK: 二叉树常用操作: 前中后序遍历，二叉树的问题基本都是递归解决，不同的就是前中后序的差异，操作与子节点之间的执行顺序
class Operator {
    func preOrder(_ root: TreeNode?) {
        guard root != nil else {
            return
        }
        print("\(root?.val ?? 0) ")
        preOrder(root?.left)
        preOrder(root?.right)
    }

    func inOrder(_ root: TreeNode?) {
        guard root != nil else {
            return
        }
        inOrder(root?.left)
        print("\(root?.val ?? 0) ")
        inOrder(root?.right)
    }
    
    func postOrder(_ root: TreeNode?) {
        guard root != nil else {
            return
        }
        postOrder(root?.left)
        postOrder(root?.right)
        print("\(root?.val ?? 0) ")
    }
    
    //层序遍历: 最短路径问题，层序遍历问题，延伸可解决图的最短路径问题（增加个visited来避免走重复路径)
    func levelSearch(_ root: TreeNode?) {
        guard let root = root else { return }
        var q: [TreeNode] = []
        var step = 0
        //避免重复访问：图的遍历
        var visited: [TreeNode] = []
        q.append(root)
        while !q.isEmpty {
            for _ in 0..<q.count {
                let node = q.removeFirst()
          
                //解决目标达成
//                if target {
//                    return step
//                }
                

                if let l = node.left {
                    q.append(l)
                }
                
                if let r = node.right {
                    q.append(r)
                }
               
                //多叉的遍历添加
//                for node in cur.nodes {
//                    if !visited.contains(node) {
//                        q.append(node)
//                        visited.append(node)
//                    }
//                }
            }
            //解决深度相关问题
            step += 1
        }
    }
}
//堆：大小堆, 堆是完全二叉树, 结构应用：优先队列
//堆的抽象父类
class Heap {
    fileprivate var nodes: [Int] = []
    private var capacity = 0 //数组实现的核心都会涉及扩容的问题
    private(set) var count = 0
    
    init(capacity: Int) {
        self.capacity = capacity
        self.nodes = Array(repeating: -1, count: capacity + 1)
    }
    
    func insert(_ val: Int) {
        if count >= capacity {
            print("堆已满")
            return
        }
        count += 1
        //添加节点
        nodes[count] = val
        bottomToTopHeapify()
    }
    
    func delete(_ val: Int) {
        //直接删除涉及的变迁太多，先做置换，然后直接删除根节点即可
        if count == 0 { return }
        self.nodes[1] = self.nodes[count]
        count -= 1
        topToBottomHeapify(n: count, i: 1)
    }
    
    func bottomToTopHeapify() {
        fatalError("子类实现")
    }
    
    func topToBottomHeapify(n: Int, i: Int) {
        fatalError("子类实现")
    }
}

class MaxHeap: Heap {
    //O(1)
    func getMax() -> Int {
        return self.count >= 1 ? self.nodes[1] : 0
    }
    
    override func bottomToTopHeapify() {
        var i = count
        while i / 2 > 0 && nodes[i] > nodes[i / 2] { //自下向上将节点置换到合适的位置
            (nodes[i], nodes[i / 2]) = (nodes[i / 2], nodes[i])
            i = i / 2
        }
    }
    
    override func topToBottomHeapify(n: Int, i: Int) { //自上向下将节点置换到合适的位置
        while true {
            var maxPos = i
            var cur = i
            if cur * 2 <= n && self.nodes[cur] < self.nodes[cur * 2] {
                maxPos = cur * 2
            }
            if (cur * 2 + 1) <= n && self.nodes[maxPos] < self.nodes[cur * 2 + 1] {
                maxPos = cur * 2 + 1
            }
            if maxPos == cur { break }
            self.nodes.swapAt(cur, maxPos)
            cur = maxPos
        }
    }
}

class MinHeap: Heap {
    //O(1)
    func getMin() -> Int {
        return self.count >= 1 ? self.nodes[1] : 0
    }
    
    override func bottomToTopHeapify() {
        var i = count
        while i / 2 > 0 && nodes[i] < nodes[i / 2] { //自下向上将节点置换到合适的位置
            (nodes[i], nodes[i / 2]) = (nodes[i / 2], nodes[i])
            i = i / 2
        }
    }
    
    override func topToBottomHeapify(n: Int, i: Int) { //自上向下将节点置换到合适的位置
        while true {
            var maxPos = i
            var cur = i
            if cur * 2 <= n && self.nodes[cur] > self.nodes[cur * 2] {
                maxPos = cur * 2
            }
            if (cur * 2 + 1) <= n && self.nodes[maxPos] > self.nodes[cur * 2 + 1] {
                maxPos = cur * 2 + 1
            }
            if maxPos == cur { break }
            self.nodes.swapAt(cur, maxPos)
            cur = maxPos
        }
    }
}

//优先队列: （是什么）队列顶部始终排着优先级最高的元素
//为什么：大的应用：赫夫曼编码、图的最短路径、最小生成树算法
//为什么：小的应用 - 合并有序小文件
//怎么做：就是实现顶堆，关键在插入的上浮和删除的下沉操作的实现
//上浮就是将元素放在尾部不断和上一个节点做对比交换
//下沉就是现将队列的首尾交换，然后从根节点开始不断向下与两个节点做对比后进行置换
class PriorityQueue {
    var queue: [Int] = []
    var capacity: Int
    private(set) var size = 0
    
    init(capacity: Int) {
        queue = Array(repeating: -1, count: capacity + 1)
        self.capacity = capacity
    }
    
    func enqueue(value: Int) {
        if size == 0 {
            queue.append(value)
        }
        size += 1
        shiftUp()
    }

    func dequeue() -> Int? {
        if self.size == 0 {
            return nil
        }
        size -= 1
        queue[1] = queue[size]
        let result = queue[1]
        //重新堆化
        if size > 0 {
            shiftDown(n: size, i: 1)
        }
        return result
    }
    
    func peek() -> Int? {
        if self.size == 0 {
            return nil
        }
        return queue[1]
    }
    
    private func shiftUp() {
        var i = size
        //注意，因为是从1位置开始m，所以左节点 = 2 * n,右节点 =2 * n + 1
        //如果是从0开始则应该是左节点 = 2 * n + 1,右节点 =2 * n + 2
        while i / 2 > 0 && queue[i] < queue[i / 2] { //自下向上将节点置换到合适的位置
            (queue[i], queue[i / 2]) = (queue[i / 2], queue[i])
            i = i / 2
        }
    }
    
    private func shiftDown(n: Int, i: Int) {
        var cur = i
        var maxPos = i
        while true {
            if queue[maxPos] > queue[cur * 2] && cur * 2 <= n {
                maxPos = cur * 2
            }
            
            if queue[maxPos] > queue[cur * 2 + 1] && cur * 2 + 1 <= n {
                maxPos = cur * 2 + 1
            }
            if cur == maxPos {
                break
            }
            self.queue.swapAt(cur, maxPos)
            cur = maxPos
        }
    }
}

//MARK: 堆的应用：堆排序, 有序合并K个有序数组, TopK, 求中位数
//堆排序:

class HeapSolution {
    func heapSort(arr: inout [Int]) {
        func buildHeap() {
            var i = arr.count / 2
            while i >= 1 {
                heapify(arr: &arr, n: arr.count, i: 1)
                i -= 1
            }
        }
        
        //大堆
        func heapify(arr: inout [Int], n: Int, i: Int) {
            var cur = i
            var maxPos = i
            while true {
                if cur * 2 <= n && arr[cur * 2] > arr[cur] {
                    maxPos = cur * 2
                }
                if cur * 2 + 1 <= n && arr[cur * 2 + 1] > arr[maxPos] {
                    maxPos = cur * 2 + 1
                }
                if cur == maxPos { break }
                arr.swapAt(cur, maxPos)
                cur = maxPos
            }
        }
    
        buildHeap()
        var j = arr.count
        while j > 1 {
            arr.swapAt(1, j)
            j -= 1
            heapify(arr: &arr, n: j, i: 1)
        }
    }
    
    func topK(k: Int, arr: [Int]) {
        let q = PriorityQueue(capacity: k)
        if k < arr.count {
            for i in 0..<k {
                q.enqueue(value: arr[i])
            }
            for j in k...arr.count {
                if arr[j] > q.peek() ?? 0 {
                    q.dequeue()
                    q.enqueue(value: arr[j])
                }
            }
        } else {
            for num in arr {
                q.enqueue(value: num)
            }
        }
    }
    
    //优先队列
    func mergeKLists2(_ lists: [ListNode?]) -> ListNode? {
        guard lists.count > 0 else {
            return nil
        }
        var queue = PriorityQueue(capacity: lists.count)
        for node in lists {
                queue.enqueue(value: node?.val ?? 0)
        }
        var dummy: ListNode? = ListNode(0)
        var p = dummy
        while queue.size > 0 {
            let v = queue.dequeue()
            p?.next = ListNode(v ?? 0)
            p = p?.next
            if p != nil { queue.enqueue(value: p?.next?.val ?? 0) }
        }
        return dummy?.next
    }
}

public class ListNode {
     public var val: Int
     public var next: ListNode?
     public init(_ val: Int) {
         self.val = val
         self.next = nil
     }
 }

//MARK: 问题

class Solution {
    //反转二叉树
    func invertTree(_ root: TreeNode?) -> TreeNode? {
        guard let root = root else { return nil }
        let left = invertTree(root.left)
        let right = invertTree(root.right)
        root.left = right
        root.right = left
        return root
    }

    var path: [Int] = []
    func hasPathSum(_ root: TreeNode?, _ sum: Int) -> Bool {
        //分类：回溯，找出满足条件的第一个解然后退出
        guard let root = root else { return false }
        return backTrack(root, sum)
    }

    func backTrack(_ root: TreeNode?, _ sum: Int) -> Bool {
        guard let root = root else { return false }
        var newSum = sum
        //选择
        path.append(root.val)

        //状态变化操作
        newSum -=  root.val
        //终止条件
        if newSum == 0 && root.left == nil && root.right == nil {
            return true
        }
        backTrack(root.left, newSum)
        backTrack(root.right, newSum)
        //撤销选择
        path.removeLast()
        return false
    }
    
    func buildTree(_ preorder: [Int], _ inorder: [Int]) -> TreeNode? {
        return helper(preorder, preStart: 0, preEnd: preorder.count - 1, inorder, inStart: 0, inEnd: inorder.count - 1)
    }

    func helper(_ preorder: [Int], preStart: Int, preEnd: Int, _ inorder: [Int], inStart: Int, inEnd: Int) -> TreeNode? {
        if preStart == preEnd { return nil }
        let root = TreeNode(preorder[preStart])
        let inRoot = inorder.findIndex { $0 == preorder[0] }
        guard let rinRoot = inRoot else { return nil }
        let leftNums = rinRoot - inStart
        root.left = helper(preorder, preStart: preStart + 1, preEnd:preStart + leftNums + 1, inorder, inStart: inStart, inEnd: rinRoot)
        root.right = helper(preorder, preStart: preStart + leftNums + 1, preEnd:preEnd, inorder, inStart: rinRoot + 1, inEnd: inEnd)
        return root
    }
    
    var pre = Int.min
    func isValidBST(_ root: TreeNode?) -> Bool {
        guard let root = root else { return true }
        if !isValidBST(root.left) {
            return false
        }
        if root.val <= pre {
            return false
        }
        pre = root.val

        return isValidBST(root.right)
    }
    
    //二叉树相关问题的两种解题思路：自顶向下（前序遍历）: 快速排序，自底向上（后序遍历）：归并排序
    func lowestCommonAncestor(_ root: TreeNode?, _ p: TreeNode?, _ q: TreeNode?) -> TreeNode? {
        //问题是从子节点开始向上递推出结果所以是后序遍历
        if root == nil || p === root || q === root {
            return root
        }
        let left = lowestCommonAncestor(root?.left, p, q)
        let right = lowestCommonAncestor(root?.right, p, q)
        if left == nil { return right }
        if right == nil { return left }
        return root
    }

}

extension Array {
    func findIndex(_ condition: (Element) -> Bool) -> Int? {
        for (index, value) in self.enumerated() {
            if condition(value) {
                return index
            }
        }
        return nil
    }
}

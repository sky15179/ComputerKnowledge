public class ListNode {
    public var val: Int
    public var next: ListNode?
    public init(_ val: Int) {
        self.val = val
        self.next = nil
    }
}

//常见问题：反转，环，合并，删除，寻找中间节点
//1.反转：正常反转，反转0...n，反转m...n
//正常反转
class Solution {
    //迭代
    func reverseList(_ head: ListNode?) -> ListNode? {
        guard head != nil else { return nil }
        var pre: ListNode? = nil
        var cur = head

        while cur != nil {
            let temp = cur?.next
            cur?.next = pre
            pre = cur
            cur = temp
        }

        return pre
    }

    //递归

    func reverseList2(_ head: ListNode?) -> ListNode? {
        if head == nil || head?.next == nil {
            return head
        }

        let result = reverseList(head?.next)
        head?.next?.next = head
        head?.next = nil

        return result
    }
}

//反转m...n：递归和拆解为反转0...n

var successor: ListNode? = nil // 后驱节点

//递归思想，reverseBetween(head.next, m: m-1, n: n -1)
func reverseBetween(_ head: ListNode?, _ m: Int, _ n: Int) -> ListNode? {
    guard head != nil else { return head }
    if m == 1 {
        //返回反转0...n
        return reverseN(head, n)
    }
    head?.next = reverseBetween(head?.next, m - 1, n-1)
    return head
}

func reverseN(_ head: ListNode?, _ n: Int) -> ListNode? {
    if n == 1 {
        successor = head?.next
        return head
    }

    let ret = reverseN(head?.next, n-1)
    head?.next?.next = head
    head?.next = successor
    return ret
}

//字符串反转1

func reverseStr(_ s: inout [Character]) {
    var left = 0, right = s.count - 1
    while left < right {
        (s[left], s[right]) = (s[right], s[left])
        left += 1
        right -= 1
    }
}

//数字反转
func reverseNum(_ num: Int) -> Int {
    var result = 0
    var num2 = num

    while num2 != 0 {
        let pop = num2 % 10
        if result > Int.max || (result == Int.max / 10 && pop > 7) {
            return 0
        }
        if result < Int.min || (result == Int.min / 10 && pop < -8) {
            return 0
        }
        result = result * 10 + pop
        num2 = num2 / 10
    }

    return result
}


//2.求是否环，求环的节点
//求链表是否有环
func hasCycle(_ head: ListNode?) -> Bool {
    //有环的话双指针一定会相遇，因为有共同节点
    var slow = head
    var fast = head?.next

    while slow?.next != nil {
        if slow === fast {
            return true
        }
        slow = slow?.next
        fast = fast?.next?.next
    }
    return false
}

//求链表的环节点是哪个

func detectCycle(_ head: ListNode?) -> ListNode? {
    guard head != nil else { return nil }
    /*快慢指针相遇时，快指针走了二倍的慢指针才能套环相关：f = 2s
     快的路径又为: 慢路径 + n倍环长度 f = s + nb, 所以 s = nb，f = 2nb 满路径等于n倍的环长度，其实可以理解为只有当慢路径为n倍环长时快慢指针才能相遇
     当相遇在环中时, 环前步数为k = nb + a， 也就是现在慢指针再走a步就能到环前节点，一个新指针和满指针同时走a步又会再次在环前节点相遇
     */

    var slow = head
    var fast = head

    while true {
        if slow == nil {
            return nil
        }
        slow = slow?.next
        fast = fast?.next?.next

        if slow === fast {
            break
        }
    }

    fast = head

    while fast?.next != nil {
        if slow === fast {
            break
        }
        slow = slow?.next
        fast = fast?.next
    }
    return slow
}


//3.合并两个链表：两个有序链表合并为一个有序链表, 合并k个排序链表，两个链表操作查找链表相交节点
//两个有序链表合并为一个有序链表
//迭代
func mergeTwoLists(_ l1: ListNode?, _ l2: ListNode?) -> ListNode? {
    guard l1 != nil || l2 != nil else {
        return l1 != nil ? l1 : l2
    }
    var h1 = l1
    var h2 = l2
    let result: ListNode? = ListNode(-1)
    var newHead: ListNode? = result
    while h1 != nil && h2 != nil {
        if h1?.val ?? 0 > h2?.val ?? 0 {
            newHead?.next = h2
            h2 = h2?.next
        } else {
            newHead?.next = h1
            h1 = h1?.next
        }
        newHead = newHead?.next
    }

    if h1 != nil {
        newHead?.next = h1
    }

    if h2 != nil {
        newHead?.next = h2
    }

    return result?.next
}

//递归
func mergeTwoLists2(_ l1: ListNode?, _ l2: ListNode?) -> ListNode? {
    if l1 == nil { return l2 }
    if l2 == nil { return l1 }

    if l1?.val ?? 0 < l2?.val ?? 0 {
        l1?.next = mergeTwoLists2(l1?.next, l2)
        return l1
    } else {
        l2?.next = mergeTwoLists2(l1, l2?.next)
        return l2
    }
}

//合并k个排序链表
func mergeKLists(_ lists: [ListNode?]) -> ListNode? {
    guard lists.count > 0 else { return nil }
    //依赖操作：查找，新链表增加节点,相似问题：合并两个链表,每个节点找到最小节点
    //分治思想：大问题划分为多个小问题，递归理解起来更简单些
    return mergeKLists(lists, 0, lists.count - 1)
}

func mergeKLists(_ lists: [ListNode?], _ left: Int, _ right: Int) -> ListNode? {
    if left == right { return lists[left] }
    let mid = left + (right - left) / 2
    let l1 = mergeKLists(lists, left, mid)
    let l2 = mergeKLists(lists, mid + 1, right)
    return mergeTwoLists2(l1, l2)
}

//两条链表操作查找链表相交节点
func getIntersectionNode(_ headA: ListNode?, _ headB: ListNode?) -> ListNode? {
    guard headA != nil, headB != nil else {
        return nil
    }
    var h1 = headA
    var h2 = headB

    while h1 !== h2 {
        if h1 == nil {
            h1 = headB
        } else {
            h1 = h1?.next
        }

        if h2 == nil {
            h2 = headA
        } else {
            h2 = h2?.next
        }
    }
    return h1
}

//4.删除倒数第N个，查找链表节点: 双指针， 删除重复元素，删除重复元素(不保留删除元素)
//删除节点
func deleteNode(_ head: ListNode?, _ val: Int) -> ListNode? {
    let dummy: ListNode? = ListNode(0)
    dummy?.next = head
    var pre: ListNode? = dummy
    var cur: ListNode? = dummy?.next

    while cur != nil {
        if cur?.val ?? 0 == val {
            pre?.next = cur?.next
            break
        }
        cur = cur?.next
        pre = pre?.next
    }

    return dummy?.next
}
//删除重复节点
func deleteDuplicates(_ head: ListNode?) -> ListNode? {
    var valueSet: Set<Int> = Set()
    let dummy: ListNode? = ListNode(-1)
    dummy?.next = head
    var pre: ListNode? = dummy
    var cur: ListNode? = dummy?.next
    while cur != nil {
        if let curValue = cur?.val, valueSet.contains(curValue) {
            pre?.next = cur?.next
            cur = cur?.next
        } else {
            if let curValue = cur?.val {
                valueSet.insert(curValue)
            }
            cur = cur?.next
            pre = pre?.next
        }
    }

    return dummy?.next
}

//删除倒数第N个
func removeNthFromEnd(_ head: ListNode?, _ n: Int) -> ListNode? {
    guard head != nil, n >= 0 else { return nil }
    let dummy: ListNode? = ListNode(0)
    dummy?.next = head
    var slow = dummy
    var fast = dummy
    for _ in 0...n {
        fast = fast?.next
    }
    while fast != nil {
        fast = fast?.next
        slow = slow?.next
    }

    slow?.next = slow?.next?.next

    return dummy?.next
}

//有序链表删除重复元素(不保留删除元素): 1.迭代，滑动窗口双指针 2.递归: 删除节点的时候迭代删除 3.Set求只出现一次的节点
func deleteDuplicates2(_ head: ListNode?) -> ListNode? {
    let dummy: ListNode? = ListNode(-1)
    dummy?.next = head
    var pre: ListNode? = dummy
    var cur: ListNode? = dummy?.next

    while cur?.next != nil && cur != nil {
        if pre?.next?.val ?? 0 == cur?.next?.val ?? 0 {
            //一直删除到不同节点, 自己也需要删除
            while cur != nil && cur?.next != nil && (pre?.next?.val ?? 0 == cur?.next?.val ?? 0) {
                cur = cur?.next
            }
            pre?.next = cur?.next
            cur = cur?.next
        } else {
            pre = pre?.next
            cur = cur?.next
        }
    }

    return dummy?.next
}

//递归
private var temp: ListNode?
func deleteDuplicates3(_ head: ListNode?) -> ListNode? {
    //终止条件
    if head == nil || head?.next == nil { return head }

    let cur = deleteDuplicates2(head?.next)
    if temp == nil {
        temp = cur
    }
    if temp?.val ?? 0 == head?.val ?? 0 {
        return temp?.next
    } else {
        head?.next = cur
        temp = head
        return head
    }
}

//5.查找中间节点，查找链表节点，查找一般都是围绕在双指针解决
func middleNode(_ head: ListNode?) -> ListNode? {
    var slow = head
    var fast = head?.next

    while fast != nil {
        slow = slow?.next
        fast = fast?.next?.next
    }

    if slow?.next?.val ?? 0 == slow?.val ?? 0 {
        return slow?.next
    } else {
        return slow
    }
}

//6.分割链表: 给定一个链表和一个特定值 x，对链表进行分隔，使得所有小于 x 的节点都在大于或等于 x 的节点之前
//两个链表合并，小于 + 节点 + 大于等于
func partition(_ head: ListNode?, _ x: Int) -> ListNode? {
    let beforeHead: ListNode? = ListNode(0)
    var before = beforeHead
    let afterHead: ListNode? = ListNode(0)
    var after = afterHead
    var cur = head
    while cur != nil {
        if cur?.val ?? 0 < x {
            before?.next = cur
            before = before?.next
        } else {
            after?.next = cur
            after = after?.next
        }
        cur = cur?.next
    }
    after?.next = nil
    before?.next = afterHead?.next

    return beforeHead?.next
}

//7.链表操作：旋转，重排链表（letcode 143），奇偶链表（需要多重操作组合）
//重排链表（letcode 143）
func reorderList(_ head: ListNode?) {
    guard head != nil else { return }
    var node1 = head
    //有链表反转, 用数组头尾双指针
    var arr: [ListNode?] = []
    while node1 != nil {
        arr.append(node1)
        node1 = node1?.next
    }

    var left = 0
    var right = arr.count - 1
    while left < right {
        arr[left]?.next = arr[right]
        left += 1
        if left == right {
            break
        }
        arr[right]?.next = arr[left]
        right -= 1
    }
    arr[left]?.next = nil
}

//混合操作：奇偶链表，回文链表
//奇偶链表: 两个指针走链表
func oddEvenList(_ head: ListNode?) -> ListNode? {
    guard head != nil, head?.next != nil else { return head }
    var odd = head
    var even = head?.next
    let evenHead = even

    while even != nil && even?.next != nil {
        odd?.next = even?.next
        odd = odd?.next
        even?.next = odd?.next
        even = even?.next
    }
    odd?.next = evenHead
    return head
}

//回文链表：双指针 + 反转链表

func isPalindrome(_ head: ListNode?) -> Bool {
    guard head != nil else { return true}

    func reveseList(_ head: ListNode?) -> ListNode? {
        if head == nil { return head }
        let result = reveseList(head?.next)
        head?.next?.next = head?.next
        head?.next = nil
        return result
    }

    func secondList(_ head: ListNode?) -> ListNode? {
        var slow = head
        var fast = head

        while fast?.next != nil && fast?.next?.next != nil {
            fast = fast?.next?.next
            slow = slow?.next
        }
        return slow
    }

    let secHead = secondList(head)
    let reversed = reveseList(secHead?.next)
    var h1 = head
    var h2 = reversed
    var result = true
    while result && h2?.next != nil {
        if (h2?.val ?? 0) != (h1?.val ?? 0) { result = false }
        h1 = h1?.next
        h2 = h2?.next
    }
    reveseList(secHead)
    return result
}

//链表旋转：给定一个链表，旋转链表，将链表每个节点向右移动 k 个位置，其中 k 是非负数。letcode61
//成环，节点的移动, 取到新的头尾，拆环
func rotateRight(_ head: ListNode?, _ k: Int) -> ListNode? {
    if head == nil { return nil }
    if head?.next == nil { return head}
    var oldTail = head
    var total = 1

    while oldTail?.next != nil {
        oldTail = oldTail?.next
        total += 1
    }
    oldTail?.next = head
    //newtail: total - k % n - 1
    var newTail = head
    for _ in 0..<(total - k % total - 1) {
        newTail = newTail?.next
    }
    let newHead = newTail?.next
    newTail?.next = nil

    return newHead
}

var res: [[Int]] = []
res.append([])

var arr = [1,3,4]


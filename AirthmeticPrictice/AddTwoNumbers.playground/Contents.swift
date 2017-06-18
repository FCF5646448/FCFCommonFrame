//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

class ListNode{
    var val:Int
    var next:ListNode?
    init(_ val:Int) {
        self.val = val
        self.next = nil
    }
}

var l1 = ListNode(5)
//l1.next = ListNode(4)
//l1.next?.next = ListNode(3)

var l2 = ListNode(5)
//l2.next = ListNode(6)
//l2.next?.next = ListNode(4)


class Solution {
    func addTwoNumbers(_ l1: ListNode?, _ l2: ListNode?) -> ListNode? {
        var l1Arr:[Int] = []
        var l2Arr:[Int] = []
        
        var temp:ListNode? = l1
        var temp2:ListNode? = l2
        
        while true {
            l1Arr.append(temp!.val)
            if temp?.next == nil {
                break
            }
            temp = temp?.next
        }
        
        while true {
            l2Arr.append(temp2!.val)
            if temp2?.next == nil {
                break
            }
            temp2 = temp2?.next
        }
        
        var resultArr:[Int] = []
        var count = l1Arr.count >= l2Arr.count ? l1Arr.count : l2Arr.count //考虑到两个链表数量不相等的情况
        
        
        for i in 0..<count {
            var temp1 = 0
            var temp2 = 0
            
            if i < l1Arr.count {
                temp1 = l1Arr[i]
            }
            if i < l2Arr.count {
                temp2 = l2Arr[i]
            }
            resultArr.append((temp1 + temp2))
        }
        
        var i = 0
        var moreElement:Bool = false
        while i < resultArr.count {
            var code = resultArr[i]
            if i == resultArr.count - 1 && code >= 10 {
                moreElement = true //考虑到最后一位有进位的情况
            }
            if code >= 10 {
                code = code - 10
                if i + 1 < resultArr.count { //大于10，后面的数加一
                    let code2 = resultArr[i+1] + 1
                    resultArr[i+1] = code2
                }
            }
            resultArr[i] = code
            i = i + 1
        }
        if moreElement {
            resultArr.append(1)
        }
        if resultArr.count > 0 {
            var list:ListNode? //这里链表的初始化是花费时间最多的地方，应该从最后一个node开始往前面生成
            for item in resultArr.reversed().enumerated() {
                var tmp:ListNode? = list
                list = ListNode(item.element)
                print(list?.val)
                list?.next = tmp
            }
            return list
        }
        return nil
    }
    
    //网上最优算法
    func addTwoNumbers2(_ l1: ListNode?, _ l2: ListNode?) -> ListNode? {
        var numAcurrentNode: ListNode? = l1
        var numBcurrentNode: ListNode? = l2
        
        var restToAdd = 0
        
        let resultFirstNode = ListNode(0)
        var buildingNode: ListNode? = resultFirstNode
        while (numAcurrentNode != nil || numBcurrentNode != nil || restToAdd > 0) {
            var currentOpe = (numAcurrentNode?.val ?? 0) + (numBcurrentNode?.val ?? 0) + restToAdd
            
            if currentOpe > 9 {
                restToAdd = 1
                currentOpe = currentOpe - 10
            } else {
                restToAdd = 0
            }
            
            buildingNode?.val = currentOpe
            numAcurrentNode = numAcurrentNode?.next
            numBcurrentNode = numBcurrentNode?.next
            if numAcurrentNode != nil || numBcurrentNode != nil || restToAdd > 0 {
                buildingNode?.next = ListNode(0)
                buildingNode = buildingNode?.next
            }
        }
        
        return resultFirstNode
    }

}

var l = Solution().addTwoNumbers2(l1, l2)
print(l)



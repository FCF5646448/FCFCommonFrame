//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

class Solution {
    func twoSum(_ nums: [Int], _ target: Int) -> [Int] {
        var dic = [Int:Int]()
        for i in 0..<nums.count{
            let value = nums[i]
            if let result = dic[target - value]{
                return [result,i]
            }
            dic[value] = i
        }
        return []
    }
}

var solu = Solution().twoSum([3,2,4], 6)
print(solu)
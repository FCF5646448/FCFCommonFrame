//
//  String+Extension.swift
//  FCFCommonTools
//
//  Created by 冯才凡 on 2017/4/6.
//  Copyright © 2017年 com.fcf. All rights reserved.
//

import Foundation
import UIKit

extension String {
    //字符串转换为CGFloat
    var floatValue:CGFloat {
        return CGFloat((self as NSString).floatValue)
    }
    
    //字符串转换为NSInteger
    var integerValue:NSInteger {
        return (self as NSString).integerValue
    }
    
    //返回NSString
    var NSStringValue:NSString{
        return  NSString(string:self) //self as NSString
    }
    
    //
    
    //返回第一次出现的指定子字符串在此字符串中的索引，也可以用来判断是非存在该字符串
    func positionOf(sub:String) -> Int {
        var pos = -1 //不存在就返回-1
        if let range = range(of: sub){
            if !range.isEmpty{
                pos = characters.distance(from: startIndex, to: range.lowerBound)
            }
        }
        return pos
    }
    
    //将原始的url编码为合法的url，例如把中文、空格、特殊符号进行转义
    func urlEncode() -> String {
        let encodeUrlString = self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        return encodeUrlString ?? ""
    }
    //将转义后的URL转换为带中文、空格、特殊符号的原始url
    func urlDecode() -> String{
        return self.removingPercentEncoding ?? ""
    }
    
    
    /**
     计算文字宽高
     - returns:
     //使用：
     let projectText="我是一段字符串，来计算我的高度吧";
     
     let projectSize=projectText.textSizeWithFont(UIFont.systemFontOfSize(14), constrainedToSize:CGSizeMake(100, 200))
     let comProjectW:CGFloat=projectSize.width;
     let comProjectH:CGFloat=projectSize.height;
     //记得要在计算的字符串UILable中加上
     UIlable.font=UIFont.systemFontOfSize(14);
     //显示几行
     UIlable.numberOfLines=1;
     
     */
    func textSizeWithFont(_ font:UIFont,constrainedToSize size:CGSize) -> CGSize{
        var textSize:CGSize!
        if size.equalTo(CGSize.zero) {
            let attributes = NSDictionary(object: font,forKey: NSFontAttributeName as NSCopying)
            textSize = self.size(attributes: attributes as! [String:AnyObject] as [String:AnyObject])
        }else{
            let option = NSStringDrawingOptions.usesLineFragmentOrigin
            let attributes = NSDictionary(object: font,forKey: NSFontAttributeName as NSCopying)
            let stringRect = self.boundingRect(with: size,options: option,attributes: attributes as! [String:AnyObject] as [String:AnyObject],context: nil)
            textSize = stringRect.size
        }
        return textSize
    }
    
    //将十进制和十六进制的字符串直接换算成数字
    func stringToInt(from:String) -> Int{
        let str = from.uppercased()
        var sum = 0
        for i in str.utf8 {
            sum = sum * 16 + Int(i) - 48 //0-9 从48开始
            if i >= 65 {
                sum -= 7    //  A-Z 从65开始，但有初始值10，所以应该是减去55
            }
        }
        return sum
    }
    
    //根据开始位置和长度截取字符串
    func subString(start:Int,length:Int = -1) -> String{
        var len = length
        if len == -1 {
            len = characters.count - start
        }
        let st = characters.index(startIndex, offsetBy: start)
        let en = characters.index(st, offsetBy: len)
        let range = st ..< en
        return substring(with: range)
    }
    //给string添加索引:get:var a = str[7,3] , set:str[7,3] = "COM"
    subscript(start:Int,length:Int) -> String{
        get{
            let index1 = self.index(self.startIndex, offsetBy: start)
            let index2 = self.index(index1, offsetBy: length)
            let range = Range(uncheckedBounds: (lower: index1, upper: index2))
            return self.substring(with: range)
        }
        set{
            let tmp = self
            var s = ""
            var e = ""
            for (idx,item) in tmp.characters.enumerated() {
                if idx < start {
                    s += "\(item)"
                }
                if idx >= start + length {
                    e += "\(item)"
                }
            }
            self = s + newValue + e
        }
    }
    //给string添加索引:get:var a = str[3] , set:str[3] = "F"
    subscript(index:Int) -> String {
        get{
            return String(self[self.index(self.startIndex, offsetBy: index)])
        }
        set{
            let tmp = self
            self = ""
            for (idx,item) in tmp.characters.enumerated() {
                if idx == index {
                    self += "\(newValue)"
                }else{
                    self += "\(item)"
                }
            }
        }
    }
    
}

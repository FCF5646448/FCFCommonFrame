//
//  ColorExtension.swift
//  FCFCommonTools
//
//  Created by 冯才凡 on 2017/4/6.
//  Copyright © 2017年 com.fcf. All rights reserved.
//

import Foundation
import UIKit

extension UIColor{
    //RBG设置颜色
    class func RGB(red:CGFloat,green:CGFloat,blue:CGFloat) -> UIColor {
        if #available(iOS 10, *) {
            return UIColor(displayP3Red: red/255, green: green/255, blue: blue/255, alpha: 1.0)
        }else{
            return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1.0)
        }
    }
    //16进制字符串设置颜色
    class func haxString(hex:String) -> UIColor {
        let scanner:Scanner = Scanner(string: hex)
        var valueRGB:UInt32 = 0
        if scanner.scanHexInt32(&valueRGB) == false {
            return UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        }else{
            return UIColor.init(
                red: CGFloat((valueRGB & 0xFF0000)>>16)/255.0,
                green: CGFloat((valueRGB & 0x00FF00)>>8)/255.0,
                blue: CGFloat(valueRGB & 0x0000FF)/255.0,
                alpha: CGFloat(1.0))
        }
    }
    //随机色
    class func randomCOlor() -> UIColor {
        arc4random()
        return UIColor.RGB(red: CGFloat(arc4random()%256), green: CGFloat(arc4random()%256), blue: CGFloat(arc4random()%256))
    }
}

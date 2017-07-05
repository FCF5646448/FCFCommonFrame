//
//  RectBrush.swift
//  FCFCommonFrame
//
//  Created by 冯才凡 on 2017/6/28.
//  Copyright © 2017年 com.fcf. All rights reserved.
//

import UIKit

//矩形
class RectBrush: BaseBrush {
    override func drawInContext(context: CGContext) {
        context.addRect(CGRect(x: min((self.beginPoint?.x)!, (self.endPoint?.x)!), y: min((self.beginPoint?.y)!, (self.endPoint?.y)!), width: abs((self.endPoint?.x)! - (self.beginPoint?.x)!), height: abs((self.endPoint?.y)! - (self.beginPoint?.y)!)))
    }
}

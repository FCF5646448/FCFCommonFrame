//
//  EllipseBrush.swift
//  FCFCommonFrame
//
//  Created by 冯才凡 on 2017/6/28.
//  Copyright © 2017年 com.fcf. All rights reserved.
//

import UIKit

//圆
class EllipseBrush: BaseBrush {
    override func drawInContext(context: CGContext) {
        context.addEllipse(in: CGRect(x: min((self.beginPoint?.x)!, (self.endPoint?.x)!), y: min((self.beginPoint?.y)!, (self.endPoint?.y)!), width: abs((self.endPoint?.x)! - (self.beginPoint?.x)!), height: abs((self.endPoint?.y)! - (self.beginPoint?.y)!)))
    }
}

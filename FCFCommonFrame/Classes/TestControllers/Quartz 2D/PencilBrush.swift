//
//  PencilBrush.swift
//  FCFCommonFrame
//
//  Created by 冯才凡 on 2017/6/16.
//  Copyright © 2017年 com.fcf. All rights reserved.
//

import UIKit

class PencilBrush: BaseBrush {
    override func drawInContext(context: CGContext) {
        if let lastP = self.lastPoint {
            context.move(to: lastP)
            context.addLine(to: self.endPoint!)
        }else{
            context.move(to: self.beginPoint!)
            context.addLine(to: self.endPoint!)
        }
    }
    
    override func supportedContinnuousDrawing() -> Bool {
        return true
    }
}

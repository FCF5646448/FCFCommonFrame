//
//  ImaginaryLineBrush.swift
//  FCFCommonFrame
//
//  Created by 冯才凡 on 2017/6/28.
//  Copyright © 2017年 com.fcf. All rights reserved.
//

import UIKit

//虚线
class ImaginaryLineBrush: BaseBrush {
    override func drawInContext(context: CGContext) {
        let lengths:[CGFloat] = [self.strokeWidth * 3,self.strokeWidth * 3]
        context.setLineDash(phase: 0, lengths: lengths)
        context.move(to: self.beginPoint!)
        context.addLine(to: self.endPoint!)
    }
}

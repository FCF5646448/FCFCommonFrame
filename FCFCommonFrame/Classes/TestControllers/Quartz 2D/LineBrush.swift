//
//  LineBrush.swift
//  FCFCommonFrame
//
//  Created by 冯才凡 on 2017/6/28.
//  Copyright © 2017年 com.fcf. All rights reserved.
//

import UIKit

//直尺
class LineBrush: BaseBrush {
    override func drawInContext(context: CGContext) {
        context.move(to: self.beginPoint!)
        context.addLine(to: self.endPoint!)
    }
}

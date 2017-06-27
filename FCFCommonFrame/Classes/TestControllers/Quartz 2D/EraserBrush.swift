//
//  EraserBrush.swift
//  FCFCommonFrame
//
//  Created by 冯才凡 on 2017/6/27.
//  Copyright © 2017年 com.fcf. All rights reserved.
//

import UIKit

//橡皮擦
class EraserBrush: PencilBrush {
    override func drawInContext(context:CGContext){
        context.setBlendMode(CGBlendMode.clear)
        super.drawInContext(context: context)
    }
}

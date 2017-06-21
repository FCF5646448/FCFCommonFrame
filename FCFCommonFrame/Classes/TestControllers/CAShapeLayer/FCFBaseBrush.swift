//
//  FCFBaseBrush.swift
//  FCFCommonFrame
//
//  Created by 冯才凡 on 2017/6/21.
//  Copyright © 2017年 com.fcf. All rights reserved.
//

import UIKit

//画笔的基类
class FCFBaseBrush: NSObject {
    var beginPoint:CGPoint? //手指按下的位置
    var endPoint:CGPoint? //手指抬起的位置
    var lastPoint:CGPoint? //手指移动到当前位置之前的位置
    var strokeWidth:CGFloat? //画笔宽度
    var strokeColor:CGColor? //画笔颜色
    
}

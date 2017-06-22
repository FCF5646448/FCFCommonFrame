//
//  FCFBaseBrush.swift
//  FCFCommonFrame
//
//  Created by 冯才凡 on 2017/6/21.
//  Copyright © 2017年 com.fcf. All rights reserved.
//

import UIKit

enum DrawingState{
    case begin
    case moved
    case ended
}

//画笔类型
enum DrawShapeType{
    case Curve //曲线
    case Line //直线
    case Ellipse //椭圆
    case Rect  //矩形
}


//画笔的基类
class FCFBaseBrush: NSObject {
    var strokeWidth:CGFloat? //画笔宽度
    var strokeColor:CGColor? //画笔颜色
    var pointsArr:[(state:DrawingState,point:CGPoint)] = []//放置点的数组
    var path:UIBezierPath? //每个画笔对应一个特定的path
    
    func addPointToArr(point:CGPoint,state:DrawingState){//将点加到数组里
//        print("子类必须重写")
    }
    
    func drawInShape(shape:inout CAShapeLayer){//绘画，将layer传进去
//        print("子类必须重写")
        shape.strokeColor = self.strokeColor
        shape.lineWidth = self.strokeWidth!
    }
    func supportedContinDrawing()->Bool{//是否连续绘画
        return false
    }
}


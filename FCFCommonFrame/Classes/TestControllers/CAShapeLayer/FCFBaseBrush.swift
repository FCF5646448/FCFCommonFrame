//
//  FCFBaseBrush.swift
//  FCFCommonFrame
//
//  Created by 冯才凡 on 2017/6/21.
//  Copyright © 2017年 com.fcf. All rights reserved.
//

import UIKit

//画笔类型
enum DrawShapeType{
    case Curve //曲线,CAShapeLayer
    case Line //直线,CAShapeLayer
    case Ellipse //椭圆,CAShapeLayer
    case Rect  //矩形,CAShapeLayer
    case Eraser //橡皮擦 ,CAShapeLayer
    case Text //文本 CATextLayer(待定)
    case Note //音符 (待定)
}
//画笔的基类
class FCFBaseBrush: NSObject {
    var penType:DrawShapeType = .Curve //默认为画曲线
    var strokeWidth:CGFloat = 1 //画笔宽度
    var strokeColor:String = "000000" //画笔颜色,十六进制,默认是黑色，0是透明色
    var pointsArr:[(state:DrawingState,point:CGPoint)] = []//放置点的数组
    var basePath:UIBezierPath = UIBezierPath() //每个画笔对应一个特定的path
    
    func addPointToArr(point:CGPoint,state:DrawingState){
        switch self.penType {
        case .Curve:
            self.pointsArr.append((state,point))
            switch state {
            case .begin:
                self.pointsArr.removeAll()
                basePath.move(to: point)
            case .moved:
                basePath.addLine(to: point)
            case .ended:
                basePath.addLine(to: point)
            }
            break
        default:
            break
        }
        
    }
    
    func drawInShape(shape:inout CAShapeLayer){
        shape.strokeColor = UIColor.haxString(hex: self.strokeColor).cgColor
        shape.lineWidth = self.strokeWidth
        
        shape.path = self.basePath.cgPath
    }
    
    func saveCurrentDraw(){
        //可以存到全局数组里，等后面进入后台以后，再写进xml文件中
        var pointArr:[CGPoint] = []
        for item in self.pointsArr {
            pointArr.append(item.point)
        }
        DrawArray.append((type: .Curve, colorStr: self.strokeColor, strokeWidth: self.strokeWidth, points: pointArr)) //将笔画数组存起来
        currentIndex = DrawArray.count
    }
}


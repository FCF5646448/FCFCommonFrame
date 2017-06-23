//
//  CurveBrush.swift
//  FCFCommonFrame
//
//  Created by 冯才凡 on 2017/6/23.
//  Copyright © 2017年 com.fcf. All rights reserved.
//

import UIKit

//class CurveBrush: FCFBaseBrush {
//    override func addPointToArr(point:CGPoint,state:DrawingState){
//        switch self.penType {
//        case .Curve:
//            self.pointsArr.append((state,point))
//            switch state {
//            case .begin:
//                self.pointsArr.removeAll()
//                tmpPath?.move(to: point)
//            case .moved:
//                tmpPath?.addLine(to: point)
//            case .ended:
//                tmpPath?.addLine(to: point)
//            }
//            break
//        default:
//            break
//        }
//        
//    }
//    
//    override func drawInShape(shape:inout CAShapeLayer){
//        shape.strokeColor = UIColor.haxString(hex: self.strokeColor).cgColor
//        shape.lineWidth = self.strokeWidth
//        
//        self.basePath.append(self.tmpPath!)//这样就能把每次画的笔画加到一起
//        
//        shape.path = self.basePath.cgPath
//    }
//    
//    override func saveCurrentDraw(){
//        //可以存到全局数组里，等后面进入后台以后，再写进xml文件中
//        var pointArr:[CGPoint] = []
//        for item in self.pointsArr {
//            pointArr.append(item.point)
//        }
//        DrawArray.append((type: .Curve, colorStr: self.strokeColor, strokeWidth: self.strokeWidth, points: pointArr)) //将笔画数组存起来
//        currentIndex = DrawArray.count
//    }
//}

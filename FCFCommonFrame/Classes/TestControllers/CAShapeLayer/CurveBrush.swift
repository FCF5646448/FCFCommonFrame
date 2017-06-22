//
//  CurveBrush.swift
//  FCFCommonFrame
//
//  Created by 冯才凡 on 2017/6/22.
//  Copyright © 2017年 com.fcf. All rights reserved.
//

import UIKit

//曲线画笔
class CurveBrush: FCFBaseBrush {
    override func addPointToArr(point:CGPoint,state:DrawingState){
        self.pointsArr.append((state,point))
        switch state {
        case .begin:
            self.path?.move(to: point)
        case .moved:
            self.path?.addLine(to: point)
        case .ended:
            self.path?.addLine(to: point)
            //可以存到全局数组里，等后面进入后台以后，再写进xml文件中
//            //将点存到userdefault，以便撤销和重做使用。
//            let userDefault = UserDefaults.standard
//            var pointStrArr:[NSMutableString] = []
//            let pointStr = NSMutableString()
//            for item in self.pointsArr {
//                let str = NSStringFromCGPoint(item.point)
//                pointStr.append(str)
//                if item != self.pointsArr.last! {
//                    pointStr.append("^") //将所有的点按^分割开来
//                }
//            }
//            if let index:Int = userDefault.integer(forKey: "Current"){
//                userDefault.set(index + 1, forKey: "Current")
//            }else{
//                userDefault.set(0, forKey: "Current")
//            }
//            pointStrArr.append(pointStr)
//            userDefault.set(pointStrArr, forKey: "pointStrArr") //将笔画数组存起来
            
        }
    }
    
    override func drawInShape( shape: inout CAShapeLayer) {
        super.drawInShape(shape: &shape)
        shape.path = self.path!.cgPath
    }
    
    override func supportedContinDrawing() -> Bool {
        return true
    }
    
}

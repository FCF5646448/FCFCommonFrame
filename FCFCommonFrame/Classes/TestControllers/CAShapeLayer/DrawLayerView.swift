//
//  DrawLayerView.swift
//  FCFCommonFrame
//
//  Created by 冯才凡 on 2017/6/21.
//  Copyright © 2017年 com.fcf. All rights reserved.
//

import UIKit

//这个图层是加在最上面的
class DrawLayerView: UIView {
    var textLayer:CATextLayer = CATextLayer() //文本
    var shapeLayer:CAShapeLayer?
    var brush:FCFBaseBrush = FCFBaseBrush()//画笔
    var ifSavePoint:Bool = true //是否需要保存数据，如果是从DrawArray里拿到的数据就不保存
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.clear
        shapeLayer = CAShapeLayer()
        shapeLayer?.frame = self.frame
        self.layer.addSublayer(shapeLayer!)
    }

    func didSelectPen(linewidth:CGFloat = 1,strokecolor:String = "000000",penType:DrawShapeType = .Curve){
        shapeLayer?.fillColor = UIColor.clear.cgColor
        shapeLayer?.lineCap = kCALineCapRound
        shapeLayer?.lineJoin = kCALineJoinRound
        
        switch penType {
        case .Curve:
            brush.penType = .Curve
            brush.strokeColor = strokecolor
            brush.strokeWidth = linewidth
            break
        case .Line:
            break
        case .Ellipse:
            break
        case .Rect:
            break
        case .Eraser:
            break
        case .Text:
            break
        case .Note:
            break
        }
    }
}

extension DrawLayerView{
    func addPoint(point:CGPoint,state:DrawingState){
        brush.addPointToArr(point: point, state: state)
        //这里应该就是调用画笔进行作画
        
        brush.drawInShape(shape: &shapeLayer!)
        if state == .ended && ifSavePoint {
            //调用保存point
            brush.saveCurrentDraw()
        }
    }
}

extension DrawLayerView{
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        ifSavePoint = true
        let point = touches.first?.location(in: self)
        self.addPoint(point: point!, state: .begin)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let point = touches.first?.location(in: self)
        self.addPoint(point: point!, state: .moved)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let point = touches.first?.location(in: self)
        self.addPoint(point: point!, state: .ended)
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("取消")
    }
}

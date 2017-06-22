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
    var shapeLayer:CAShapeLayer = CAShapeLayer() //最好只有一层
    var brush:FCFBaseBrush? //画笔
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.clear
        self.layer.addSublayer(shapeLayer)
    }
    
    func didSelectPen(linewidth:CGFloat = 1,strokecolor:CGColor = UIColor.clear.cgColor,penType:DrawShapeType = .Curve){
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineCap = kCALineCapRound
        shapeLayer.lineJoin = kCALineJoinRound
        
        switch penType {
        case .Curve:
            brush = CurveBrush()
            brush?.path = UIBezierPath()
            brush?.path?.lineJoinStyle = .round
            brush?.path?.lineCapStyle = .round
            brush?.strokeColor = strokecolor
            brush?.strokeWidth = linewidth
            break
        case .Line:
            
            break
        case .Ellipse:
            
            break
        case .Rect:
            
            break
        }
    }
}

extension DrawLayerView{
    func Draw(){
        //这里应该就是调用画笔进行作画
        if let brush = brush {
            brush.drawInShape(shape: &self.shapeLayer)
        }
    }
}

extension DrawLayerView{
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let point = touches.first?.location(in: self)
        if let brush = brush {
            brush.addPointToArr(point: point!, state: .begin)
            Draw()
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let point = touches.first?.location(in: self)
        if let brush = brush {
            brush.addPointToArr(point: point!, state: .moved)
            Draw()
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let point = touches.first?.location(in: self)
        if let brush = brush {
            brush.addPointToArr(point: point!, state: .ended)
            Draw()
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("取消")
    }
}

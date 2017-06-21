//
//  CAShapeLayerTestController.swift
//  FCFCommonFrame
//
//  Created by 冯才凡 on 2017/6/21.
//  Copyright © 2017年 com.fcf. All rights reserved.
//

import UIKit

class CAShapeLayerTestController: BaseViewController {
    
    var path = UIBezierPath() 
    let shapeLayer:CAShapeLayer = CAShapeLayer() //最好只有一层
    
    var drawingState:DrawingState? //当前绘画状态
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "CAShapeLayer的基本使用"
        
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.lineWidth = 3
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineCap = kCALineCapRound
        shapeLayer.lineJoin = kCALineJoinRound
        self.view.layer.addSublayer(shapeLayer)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}

extension CAShapeLayerTestController{
    //画
    func getDraw() {
        shapeLayer.path = self.path.cgPath
    }
}

extension CAShapeLayerTestController{
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let point = touches.first?.location(in: self.view)
        self.drawingState = .begin
        path.move(to: point!)
        getDraw()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let point = touches.first?.location(in: self.view)
        self.drawingState = .moved
        path.addLine(to: point!)
        getDraw()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let point = touches.first?.location(in: self.view)
        self.drawingState = .ended
        path.addLine(to: point!)
        getDraw()
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("取消")
    }
}


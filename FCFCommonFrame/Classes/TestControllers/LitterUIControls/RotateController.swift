//
//  RotateController.swift
//  FCFCommonFrame
//
//  Created by 冯才凡 on 2017/6/29.
//  Copyright © 2017年 com.fcf. All rights reserved.
//

import UIKit

class RotateController: BaseViewController {
    var myView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        myView = UIView(frame: CGRect(x: 100, y: 150, width: 100, height: 20))
//        myView.center = self.view.center
        myView.backgroundColor = UIColor.red
        self.view.addSubview(myView)
        myView.layer.anchorPoint = CGPoint(x: 0, y: 0.5)
        
        let box = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        box.backgroundColor = UIColor.blue
        myView.addSubview(box)
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first?.location(in: self.view)
        let target = myView.center
        let angle = atan2(touch!.y-target.y, touch!.x-target.x)
        myView.transform = CGAffineTransform(rotationAngle: angle)
    }
}

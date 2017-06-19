//
//  CALayerTestController.swift
//  FCFCommonFrame
//
//  Created by 冯才凡 on 2017/6/19.
//  Copyright © 2017年 com.fcf. All rights reserved.
//

import UIKit
import QuartzCore

class CALayerTestController: BaseViewController {

    var layerView:UIView!
    
    var blueLayer:CALayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.gray
        createLayer()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createLayer(){
        layerView = UIView(frame: CGRect(x: (ContentWidth-200)/2, y: (ContentHeight-200)/2, width: 200, height: 200))
        layerView.backgroundColor = UIColor.white
        self.view.addSubview(layerView)
        
        blueLayer = CALayer()
        blueLayer.frame = CGRect(x: 50, y: 50, width: 100, height: 100)
        blueLayer.backgroundColor = UIColor.blue.cgColor
        layerView.layer.addSublayer(blueLayer)
        let img = UIImage(named: "BROOK")
        blueLayer.contents = img?.cgImage //基本是UIImage类型，其他类型没有效果
        blueLayer.contentsRect = CGRect.init(x: 0, y: 0, width: 0.5, height: 0.5) //显示图的某一部分，按坐标来的，1的话就是显示全部
        
        blueLayer.contentsGravity = kCAGravityCenter //类似于UIImage的contentMode
//        blueLayer.contentsScale = (img?.scale)! //按图片大小缩放
        blueLayer.masksToBounds = true // 是否显示超出Layer.frame范围的内容
//        blueLayer.contentsCenter = CGRect.init(x: 0.25, y: 0.25, width: 0.5, height: 0.5) //它定义了一个图片可拉伸的区域
        blueLayer.delegate = self
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let point = touches.first?.location(in: self.view)
        //contains
        if blueLayer.contains(point!) {
            print("contain1")
        }
        
        //hittest
        let layer = self.layerView.layer.hitTest(point!)
        if layer == blueLayer {
            print("contain2")
        }
        
    }
    
}

extension CALayerTestController:CALayerDelegate{
    //事先会先调用draw(_ layer: CALayer），如果没有实现就会找draw(_ layer: CALayer, in ctx: CGContext)函数
    func draw(_ layer: CALayer, in ctx: CGContext) {
        //使用Core Graphics画图,这里会返回图层的Context给你，直接用就好
        ctx.setLineWidth(10)
        ctx.setStrokeColor(UIColor.red.cgColor)
        ctx.strokeEllipse(in: layer.bounds)
    }
}

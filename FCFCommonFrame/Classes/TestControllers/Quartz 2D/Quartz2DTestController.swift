//
//  Quartz2DTestController.swift
//  FCFCommonFrame
//
//  Created by 冯才凡 on 2017/6/16.
//  Copyright © 2017年 com.fcf. All rights reserved.
//

import UIKit

enum DrawingState{
    case begin
    case moved
    case ended
}

//画图的原理就是每次从上一点画到下一点
class Quartz2DTestController: BaseViewController {

    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var segment: UISegmentedControl!
    
    var brush:BaseBrush? //画笔
    
    var drawingState:DrawingState? //当前绘画状态
    
    var realImg:UIImage? //当前图片
    
    var strokeWidth:CGFloat = 1.0 //画笔宽度
    
    var strokeColor:UIColor = UIColor.black //画笔颜色
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "画板"
        self.brush = PencilBrush()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    //复原
    @IBAction func backoutSelected(_ sender: Any) {
//        if let brush = self.brush {
////            let userdefault = UserDefaults.standard
////            //取
////            let imgObjData = userdefault.data(forKey: "contexts")
////            //还原对象
////            let contexts = NSKeyedUnarchiver.unarchiveObject(with: imgObjData!) as! [CGContext]
//            
//            for context in contexts {
//                //把图片画进去
//                if let img = self.realImg {
//                    img.draw(in: self.view.bounds)
//                }
//                
//                //设置brush的基本属性
//                brush.strokeWidth = self.strokeWidth
//                brush.drawInContext(context: context)
//                context.strokePath() //
//                
//                //从当前的context中得到Image，如果是ended状态或者需要支持连续不断的绘图，则将Image保存到bgImg里
//                let previewImage =  UIGraphicsGetImageFromCurrentImageContext() //拿到当前图片
//                if self.drawingState == .ended || brush.supportedContinnuousDrawing() {
//                    self.realImg = previewImage
//                }
//                //实时显示当前的绘制状态，并记录最后一个点
//                self.imgView.image = previewImage
//                brush.lastPoint = brush.endPoint
//            }
//        }
    }
    
    //重做
    @IBAction func redrawSelected(_ sender: Any) {
        
    }
}

extension Quartz2DTestController{
    func drawing(){
        if let brush = self.brush {
            //创建一个位图上下文
            UIGraphicsBeginImageContext(self.view.bounds.size)
            //初始化context（宽度、颜色、圆润度）
            let context = UIGraphicsGetCurrentContext()
            UIColor.clear.setFill()
            UIRectFill(self.view.bounds)
            context?.setLineCap(CGLineCap.round)
            context?.setLineWidth(self.strokeWidth)
            context?.setStrokeColor(UIColor.red.cgColor)
            
            //把图片画进去
            if let img = self.realImg {
                img.draw(in: self.view.bounds)
            }
            
            //设置brush的基本属性
            brush.strokeWidth = self.strokeWidth
            brush.drawInContext(context: context!)
            context!.strokePath() //
            
            //从当前的context中得到Image，如果是ended状态或者需要支持连续不断的绘图，则将Image保存到bgImg里
            let previewImage = UIGraphicsGetImageFromCurrentImageContext() //拿到当前图片
            if self.drawingState == .ended || brush.supportedContinnuousDrawing() {
                self.realImg = previewImage
            }
            
            UIGraphicsEndImageContext()
            
            brush.contents.append(context!)
            //实时显示当前的绘制状态，并记录最后一个点
            self.imgView.image = previewImage
            brush.lastPoint = brush.endPoint
        }
    }
}

extension Quartz2DTestController{
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let brush = self.brush {
            brush.lastPoint = nil
            brush.beginPoint = touches.first!.location(in: self.view)
            brush.endPoint = brush.beginPoint
            self.drawingState = .begin
            self.drawing()
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let brush = self.brush {
            brush.endPoint = touches.first?.location(in: self.view)
            self.drawingState = .moved
            self.drawing()
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let brush = self.brush {
            brush.endPoint = touches.first?.location(in: self.view)
            self.drawingState = .ended
            self.drawing()
            
            //将context数组存到userdefault
//            let userDefault = UserDefaults.standard
//            let contents = NSKeyedArchiver.archivedData(withRootObject: brush.contents)
//            userDefault.set(contents, forKey: "contexts")
        }
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let brush = self.brush {
            brush.endPoint = nil
        }
    }
}

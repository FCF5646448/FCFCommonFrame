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
    
    @IBOutlet weak var bgImage: UIImageView!
    
    var realImg:UIImage? //当前图片
    
    var strokeWidth:CGFloat = 1.0 //画笔宽度
    
    var strokeColor:UIColor = UIColor.black //画笔颜色
    
    var currentIndex:Int = -1 //笔画缓存的下标，-1表示没有缓存
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "画板"
        self.brush = PencilBrush()
        self.bgImage.image = UIImage(named:"qupu")
        let userdefault = UserDefaults.standard
        if let contexts = userdefault.array(forKey: "contexts") {
            self.currentIndex = contexts.count - 1 //把当前定义为最后一张图
            self.imgView.image = self.getCacheImg(index: self.currentIndex)
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIApplicationDidEnterBackground, object: nil, queue: OperationQueue.main) { (notification) in
            //程序进入后台，就把缓存里的笔画存为当前的笔画，之前被回撤的笔画就会消失掉
            let userdefault = UserDefaults.standard
            if let contexts = userdefault.array(forKey: "contexts") {
                var contextArr = contexts
                if self.currentIndex < 0{
                    userdefault.set(nil, forKey: "contexts")
                }else if self.currentIndex < contexts.count && self.currentIndex >= 0 {
                    let n = contextArr.count - (self.currentIndex + 1)
                    contextArr.removeLast(n) //移除最后n个元素
                    userdefault.set(contextArr, forKey: "contexts")
                }
            }
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    //复原 减笔画
    @IBAction func backoutSelected(_ sender: Any) {
        self.currentIndex = self.currentIndex - 1
        self.imgView.image = self.getCacheImg(index: self.currentIndex)
    }
    
    //重做 加笔画
    @IBAction func redrawSelected(_ sender: Any) {
        self.currentIndex = self.currentIndex + 1
        self.imgView.image = self.getCacheImg(index: self.currentIndex)
    }
    
    func getCacheImg(index:Int)->UIImage?{
        let userdefault = UserDefaults.standard
        if let contexts = userdefault.array(forKey: "contexts") {
            if index >= contexts.count {
                self.currentIndex = contexts.count - 1
                let imgD = contexts[currentIndex] as! Data
                let img = NSKeyedUnarchiver.unarchiveObject(with: imgD) as! UIImage
                return img
            }else if index >= 0 { //index < contexts.count &&
                let imgD = contexts[index] as! Data
                let img = NSKeyedUnarchiver.unarchiveObject(with: imgD) as! UIImage
                return img
            }else {
                self.currentIndex = -1
            }
        }
        return nil
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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
            brush.contents.append(self.realImg!) //将最后一幅图存起来
            
            let userDefault = UserDefaults.standard
            var imgData:[Data] = []
            for img in brush.contents{
                let imgD = NSKeyedArchiver.archivedData(withRootObject: img)
                imgData.append(imgD)
            }
            self.currentIndex = imgData.count - 1
            userDefault.set(imgData, forKey: "contexts")
        }
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let brush = self.brush {
            brush.endPoint = nil
        }
    }
}

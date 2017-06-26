//
//  DrawContext.swift
//  FCFCommonFrame
//
//  Created by 冯才凡 on 2017/6/26.
//  Copyright © 2017年 com.fcf. All rights reserved.
//

import UIKit

var drawData:[((type:DrawType,colorStr:String,strokeWidth:CGFloat,points:[CGPoint],imageData:Data))] = [] //这个数组就是存储每一笔的相关数据，points就是每一笔所经过的点，imageData就是图片数据

enum DrawingState{
    case begin
    case moved
    case ended
}

//画笔类型
enum DrawType{
    enum PenType {
        case Curve //曲线,CAShapeLayer
        case Line //直线,CAShapeLayer
    }
    case Pentype(PenType)
    enum FormType{
        case Ellipse //椭圆,CAShapeLayer
        case Rect  //矩形,CAShapeLayer
    }
    case Formtype(FormType)
    case Eraser //橡皮擦 ,CAShapeLayer
    case Text //文本 CATextLayer(待定)
    case Note //音符 (待定)
}

//所有的画画都在这里操作
class DrawContext: UIImageView {

    //管理返回重画
    fileprivate class drawManager{
        
    }
    
    var brush:BaseBrush? //画笔
    var drawingState:DrawingState? //当前绘画状态
    var realImg:UIImage? //当前图片,它只是一个临时缓存作用
    var drawType:DrawType? //画笔类型
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    //初始化🖌️，设置默认为曲线、黑色、笔宽为1.0
    func initBrush(type:DrawType? = .Pentype(.Curve),color:String? = "000000",width:CGFloat? = 1.0){
        switch type! {
        case .Pentype(.Curve):
            print("曲线")
            brush = PencilBrush()
            brush?.strokeWidth = width!
            brush?.strockColor = UIColor.haxString(hex: color!).cgColor
            
        case .Pentype(.Line):
            print("直线")
        
        case .Formtype(.Rect):
            print("矩形")
        
        case .Formtype(.Ellipse):
            print("椭圆")
            
        case .Eraser:
            
            print("橡皮擦")
        case .Note:
            print("音符")
        case .Text:
            print("文本")
        }
    }
    
}

extension DrawContext{
    func drawing(){
        if let brush = self.brush {
            //创建一个位图上下文
            UIGraphicsBeginImageContext(self.bounds.size)
            //初始化context（宽度、颜色、圆润度）
            let context = UIGraphicsGetCurrentContext()
            UIColor.clear.setFill()
            UIRectFill(self.bounds)
            context?.setLineCap(CGLineCap.round)
            context?.setLineWidth(brush.strokeWidth)
            
            context?.setStrokeColor(brush.strockColor)
            
            //把图片画进去
            if let img = self.realImg { //
                img.draw(in: self.bounds)
            }
            
            //设置brush的基本属性
            brush.drawInContext(context: context!)
            context!.strokePath() //
            
            //从当前的context中得到Image，如果是ended状态或者需要支持连续不断的绘图，则将Image保存到bgImg里
            let previewImage = UIGraphicsGetImageFromCurrentImageContext() //拿到当前图片
            if self.drawingState == .ended || brush.supportedContinnuousDrawing() {
                self.realImg = previewImage //
            }
            
            UIGraphicsEndImageContext()
            
            //实时显示当前的绘制状态，并记录最后一个点
            self.image = previewImage
            brush.lastPoint = brush.endPoint
        }
    }
    
    func saveTodataArray(){
        
        //将context数组存到userdefault
        //        brush.contents.append(self.realImg!) //将最后一幅图存起来
        //
        //        let userDefault = UserDefaults.standard
        //        var imgData:[Data] = []
        //        for img in brush.contents{
        //            let imgD = NSKeyedArchiver.archivedData(withRootObject: img)
        //            imgData.append(imgD)
        //        }
        //        self.currentIndex = imgData.count - 1
        //        userDefault.set(imgData, forKey: "contexts")
    }
}

//处理手指触碰
extension DrawContext{
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let brush = self.brush {
            brush.lastPoint = nil
            brush.beginPoint = touches.first!.location(in: self)
            brush.endPoint = brush.beginPoint
            self.drawingState = .begin
            self.drawing()
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let brush = self.brush {
            brush.endPoint = touches.first?.location(in: self)
            self.drawingState = .moved
            self.drawing()
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let brush = self.brush {
            brush.endPoint = touches.first?.location(in: self)
            self.drawingState = .ended
            self.drawing()
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let brush = self.brush {
            brush.endPoint = nil
        }
    }
}


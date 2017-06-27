//
//  DrawContext.swift
//  FCFCommonFrame
//
//  Created by 冯才凡 on 2017/6/26.
//  Copyright © 2017年 com.fcf. All rights reserved.
//

import UIKit

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

//自定义一个数据模型，有下标、image、textview,如果是图片，就txtview为nil，如果是文本，就UIImage为nil
class DrawModel:NSObject{
    var indexKey:Int = -1
    var img:UIImage?
    var txtview:DrawTextView?
}

//全局单例,用来存储每次画的笔画的相关数据
class DrawManager{
    static let shareInstance = DrawManager()
    private init(){}
    
    var index = -1
    //存储每一笔的相关数据，type:类型;colorStr:笔画颜色或文本文字颜色;strokeWidth笔画宽度，如果是文本就是文本文字最终(缩放之后)大小;points：就是每一笔所经过的点，如果是文本或者图片就存放中心点;imageData就是图片数据;Width:文本或者图片的最终(缩放之后)宽度,其他类型就为0;Height:文本或图片的最终(缩放之后)高度,其他类型就为0;Rotate:旋转角度,其他类型就为0
    var drawData:[((type:DrawType,colorStr:String,strokeWidth:CGFloat,points:[CGPoint],imageData:Data,Width:CGFloat? ,Height:CGFloat? ,Rotate:CGFloat? ))] = [] //Scale:CGFloat
    //数组保存图片,存放每一笔的图片,如果是文本则存一个空的UIImage()，
    var imgArr = [UIImage]()
    //可以撤回
    var canUndo:Bool{
        get {
            return index != -1
        }
    }
    //可以重做
    var canRedo:Bool{
        get {
            return index + 1 <= imgArr.count
        }
    }
    //添加图片
    func addImg(_ img:UIImage){
        if index == -1{
            imgArr.removeAll()
        }
        imgArr.append(img)
        index = imgArr.count - 1
    }
    //撤回时候需要的图片
    func imgForUndo()->UIImage?{
        index = index - 1
        if index >= 0 {
            return imgArr[index]
        }else{
            index = -1
            return nil
        }
    }
    //重做时需要的图片
    func imgForRedo()->UIImage?{
        index = index + 1
        if index <= imgArr.count - 1 {
            return imgArr[index]
        }else{
            if index >= 0 && imgArr.count > 0 {
                index = imgArr.count - 1
                return imgArr[index]
            }
            index = -1
            return nil
        }
    }
    
    var hasDrawed:Bool{
        get {
            return imgArr.count > 0 ? true : false
        }
    }
    //获取最上层图片
    func getTopImg() -> UIImage? {
        if imgArr.count > 0 {
            index = imgArr.count - 1
            return imgArr[imgArr.count - 1]
        }
        return nil
    }
    
    //每缓存一次就应该清理一下数组
    func clearArr(){
        self.imgArr.removeAll()
        self.drawData.removeAll()
        self.index = -1
    }
}

//所有的画画都在这里操作
class DrawContext: UIImageView {
    var boardUndoManager = DrawManager.shareInstance
    var canUndo:Bool{get{return self.boardUndoManager.canUndo}}
    var canRedo:Bool{get{return self.boardUndoManager.canRedo}}
    var hasDraw:Bool{get{return self.boardUndoManager.hasDrawed}}
    
    var brush:BaseBrush? //画笔
    var drawingState:DrawingState? //当前绘画状态
    var realImg:UIImage? //当前图片,它只是一个临时缓存作用
    var drawType:DrawType? //画笔类型
    
//    lazy var textView:DrawTextView = {
//        //默认3行
//        let textView = DrawTextView.init(frame: CGRect(x: (self.brush?.beginPoint?.x)!, y: (self.brush?.beginPoint?.y)!, width: 200, height: 24 * 3), size: (self.brush?.strokeWidth)!, color: (self.brush?.strockColor)!)
//        return textView
//    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    //初始化🖌️，设置默认为曲线、黑色、笔宽为1.0
    func initBrush(type:DrawType? = .Pentype(.Curve),color:String? = "000000",width:CGFloat? = 1.0){
        self.drawType = type
        switch self.drawType! {
        case .Pentype(.Curve):
            print("曲线")
            brush = PencilBrush()
            brush?.strokeWidth = width!
            brush?.strockColor = color!
            
        case .Pentype(.Line):
            
            print("直线")
        case .Formtype(.Rect):
            
            print("矩形")
        case .Formtype(.Ellipse):
            
            print("椭圆")
        case .Eraser:
            print("橡皮擦")
            brush = EraserBrush()
            brush?.strokeWidth = width!
            brush?.strockColor = color!
        case .Note:
            
            print("音符")
        case .Text:
            print("文本")
            brush = TextBrush()
            brush?.strockColor = color!
            brush?.strokeWidth = width!
        }
    }
    
}

extension DrawContext{
    //这个方法只适用于直线、曲线、椭圆、矩形、橡皮擦等类型
    func drawShapeing(){
        if let brush = self.brush {
            //创建一个位图上下文
            UIGraphicsBeginImageContext(self.bounds.size)
            //初始化context（宽度、颜色、圆润度）
            let context = UIGraphicsGetCurrentContext()
            UIColor.clear.setFill()
            UIRectFill(self.bounds)
            context?.setLineCap(CGLineCap.round)
            context?.setLineWidth(brush.strokeWidth)
            
            context?.setStrokeColor(UIColor.haxString(hex: brush.strockColor).cgColor)
            
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
            if self.drawingState == .ended {
                //将图片存进数组中
                self.boardUndoManager.addImg(previewImage!)
                //将点集存进数组
                let imgData = NSKeyedArchiver.archivedData(withRootObject: self.image!)
                self.boardUndoManager.drawData.append(((type: self.drawType!, colorStr: brush.strockColor, strokeWidth: brush.strokeWidth, points: brush.pointsArr, imageData: imgData, Width: 0, Height: 0, Rotate: 0)))
            }
            brush.lastPoint = brush.endPoint
        }
    }
    
    //文本
    func drawText(){
        if self.brush != nil {
            //默认3行
            let textView = DrawTextView(frame: CGRect(x: (self.brush?.beginPoint?.x)!, y: (self.brush?.beginPoint?.y)!, width: 200, height: 24 * 3), size: (self.brush?.strokeWidth)!, color: (self.brush?.strockColor)!)
            textView.becomeFirstResponder()
            textView.delegate = self
            self.addSubview(textView)
        }
    }
    
    //是否可重做
    func canForward()->Bool{
        return self.canRedo
    }
    //是否可撤销
    func canBack()->Bool{
        return self.canUndo
    }
    //撤销
    func undo() {
        if self.canUndo == false {
            return
        }
        self.image = self.boardUndoManager.imgForUndo()
        self.realImg = self.image
        //已经撤销到第一张
        if self.boardUndoManager.index == -1 {
            //
        }
    }
    //重做
    func redo() {
        if self.canRedo == false {
            return
        }
        self.image = self.boardUndoManager.imgForRedo()
        self.realImg = self.image
        //已经前进到最后一张图片
        if self.boardUndoManager.index == self.boardUndoManager.imgArr.count - 1 {
            //
        }
    }
    
    //拿取到最上层图片
    func getTopImg(){
        if self.hasDraw == false{
            return
        }
        self.image = self.boardUndoManager.getTopImg()
        self.realImg = self.image
    }
    
}

extension DrawContext:UITextViewDelegate{
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
        }
        return true
    }
}

//处理手指触碰
extension DrawContext{
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let point:CGPoint = (touches.first?.location(in: self))!
        if let brush = self.brush {
            brush.lastPoint = nil
            brush.beginPoint = point
            brush.endPoint = brush.beginPoint
            self.drawingState = .begin
            if brush.classForKeyedArchiver == PencilBrush.classForCoder() || brush.classForKeyedArchiver == EraserBrush.classForCoder() {
                
                brush.pointsArr.append(point)
                self.drawShapeing()
            }else if brush.classForKeyedArchiver == TextBrush.classForCoder() {
                brush.pointsArr.append(point) //原点位置
                self.drawText()
            }else{
                
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let point:CGPoint = (touches.first?.location(in: self))!
        if let brush = self.brush {
            brush.pointsArr.removeAll()
            brush.endPoint = point
            self.drawingState = .moved
            brush.pointsArr.append(point)
            self.drawShapeing()
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let point:CGPoint = (touches.first?.location(in: self))!
        if let brush = self.brush {
            brush.endPoint = point
            self.drawingState = .ended
            brush.pointsArr.append(point)
            self.drawShapeing()
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let brush = self.brush {
            brush.endPoint = nil
        }
    }
}


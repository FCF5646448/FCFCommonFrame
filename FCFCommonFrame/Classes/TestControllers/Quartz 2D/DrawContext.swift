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

//自定义一个数据模型，有image、textview,如果是图片，就txtview为nil，如果是文本，就UIImage为nil
class DrawModel:NSObject{
    var imgData:Data?
    var textData:Data?
    
//    let labeldata = NSKeyedArchiver.archivedData(withRootObject: label)
//    userdefault.set(labeldata, forKey: "labelData")
//    
//    //读取
//    let labelObjdata = userdefault.data(forKey: "labelData")
//    let mylabel = NSKeyedUnarchiver.unarchiveObject(with: labelObjdata!) as? UILabel
//    self.view.addSubview(mylabel!)
    
}

//全局单例,用来存储每次画的笔画的相关数据
class DrawManager{
    static let shareInstance = DrawManager()
    private init(){}
    
    var index = -1
    //存储每一笔的相关数据，type:类型;colorStr:笔画颜色或文本文字颜色;strokeWidth笔画宽度，如果是文本就是文本文字最终(缩放之后)大小;points：就是每一笔所经过的点，如果是文本或者图片就存放中心点;imgData:就是图片数据;textStr:文本String,文本就是文字内容;Width:文本或者图片的最终(缩放之后)宽度,其他类型就为0;Height:文本或图片的最终(缩放之后)高度,其他类型就为0;Rotate:旋转角度,其他类型就为0
    var drawData:[((type:DrawType,colorStr:String,strokeWidth:CGFloat,points:[CGPoint],imgData:Data,textStr:String,Width:CGFloat? ,Height:CGFloat? ,Rotate:CGFloat? ))] = [] //Scale:CGFloat
    //数组保存图片,存放每一笔的图片\文本，
    var modelArr = [DrawModel]()
    //这里就存储文本，key值是对应modelArr中对应的下标，值是图片
    var textViewArr:[(index:Int,txv:Data)] = []
    
    //可以撤回
    var canUndo:Bool{
        get {
            return index != -1
        }
    }
    //可以重做
    var canRedo:Bool{
        get {
            return index + 1 <= modelArr.count
        }
    }
    //添加图片或文本
    func addModel(_ obj:DrawModel){
        if index == -1{
            modelArr.removeAll()
        }
        if let textV = obj.textData {
            textViewArr.append((index: index, txv: textV))
        }
        modelArr.append(obj)
        index = modelArr.count - 1
    }
    //撤回时候需要的model
    func modelForUndo()->DrawModel?{
        index = index - 1
        if index >= 0 {
            return modelArr[index]
        }else{
            index = -1
            return nil
        }
    }
    //重做时需要的model
    func modelForRedo()->DrawModel?{
        index = index + 1
        if index <= modelArr.count - 1 {
            return modelArr[index]
        }else{
            if index >= 0 && modelArr.count > 0 {
                index = modelArr.count - 1
                return modelArr[index]
            }
            index = -1
            return nil
        }
    }
    
    var hasDrawed:Bool{
        get {
            return modelArr.count > 0 ? true : false
        }
    }
    //刚进来的时候，获取最上层的“图片model”，文本则要重头加
    func getTopImg() -> DrawModel? {
        index = modelArr.count - 1
        for obj in modelArr.reversed() {
            if obj.imgData != nil {
                return obj
            }
        }
        return nil
    }
    
    //每缓存一次就应该清理一下数组
    func clearArr(){
        self.modelArr.removeAll()
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
                let imgData = NSKeyedArchiver.archivedData(withRootObject: self.image!)
                //将图片存进数组中
                let obj = DrawModel()
                obj.imgData = imgData
                self.boardUndoManager.addModel(obj)
                //将点集存进数组
                
                self.boardUndoManager.drawData.append(((type: self.drawType!, colorStr: brush.strockColor, strokeWidth: brush.strokeWidth, points: brush.pointsArr, imgData:imgData,textStr:"", Width: 0, Height: 0, Rotate: 0)))
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
        if let obj = self.boardUndoManager.modelForUndo(){
            if let imgData = obj.imgData {
                let img = NSKeyedUnarchiver.unarchiveObject(with: imgData) as! UIImage
                self.image = img
                self.realImg = self.image
            }else if let textData = obj.textData{
                //文本,将文本移除，待续
                let textView = NSKeyedUnarchiver.unarchiveObject(with: textData) as! DrawTextView
                textView.removeFromSuperview()
            }
        }
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
        if let obj = self.boardUndoManager.modelForRedo() {
            if let imgData = obj.imgData {
                let img = NSKeyedUnarchiver.unarchiveObject(with: imgData) as! UIImage
                self.image = img
                self.realImg = self.image
            }else if let textData = obj.textData{
                //文本,将文本移除，待续
                let textView = NSKeyedUnarchiver.unarchiveObject(with: textData) as! DrawTextView
                self.addSubview(textView)
            }
        }
        
        //已经前进到最后一张图片
        if self.boardUndoManager.index == self.boardUndoManager.modelArr.count - 1 {
            //
        }
    }
    
    //还原原来的图层样式，将最顶层的图片取出来作为realImg，再将文本加进来。
    func restoreDraw(){
        if self.hasDraw == false{
            return
        }
        
        if let obj = self.boardUndoManager.getTopImg() {
            if let imgData = obj.imgData {
                let img = NSKeyedUnarchiver.unarchiveObject(with: imgData) as! UIImage
                self.image = img
                self.realImg = self.image
            }
        }
        
        //将文本加上去，这里虽然不是按顺序加的，但是在modelArr中是有顺序记录的
        for (_,textData) in self.boardUndoManager.textViewArr {
            let textView = NSKeyedUnarchiver.unarchiveObject(with: textData) as! DrawTextView
            self.addSubview(textView)
        }
        
    }
    
}

extension DrawContext:UITextViewDelegate{
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            //将图片存进数组中
            let textDTView = DrawTextView(frame: textView.frame, size: (self.brush?.strokeWidth)!, color: (self.brush?.strockColor)!)
            let dataDTView = NSKeyedArchiver.archivedData(withRootObject: textDTView)
            let obj = DrawModel()
            obj.textData = dataDTView
            self.boardUndoManager.addModel(obj)
            //将点集存进数组
            
            self.boardUndoManager.drawData.append(((type: self.drawType!, colorStr: (self.brush?.strockColor)!, strokeWidth: (self.brush?.strokeWidth)!, points: (self.brush?.pointsArr)!, imgData:Data(),textStr:textView.text, Width: 200, Height: 24 * 3, Rotate: 0)))
            
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


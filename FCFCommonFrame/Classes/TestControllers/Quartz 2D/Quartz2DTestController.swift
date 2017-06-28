//
//  Quartz2DTestController.swift
//  FCFCommonFrame
//
//  Created by 冯才凡 on 2017/6/16.
//  Copyright © 2017年 com.fcf. All rights reserved.
//

import UIKit


//1、将每次画的东西先存到全局类里
//2、然后在app关闭的时候，将画的东西转成xml文档
//3、每次打开页面的时候，先从全局数组里拿到数据，没有的话，从xml里将数据拿到，然后缓存到数组里，生成新的图片。将图片放到全局数组里

//画图的原理就是每次从上一点画到下一点
class Quartz2DTestController: BaseViewController {

    @IBOutlet weak var drawContext: DrawContext!
    
    @IBOutlet weak var segment: UISegmentedControl!
    
    @IBOutlet weak var bgImage: UIImageView! //曲谱背景
    
    @IBOutlet weak var forwardBtn: UIButton!
    
    @IBOutlet weak var backBtn: UIButton!
    
    @IBOutlet weak var colorBtn: UIButton!
    
    @IBOutlet weak var fontSizeSlide: UISlider!
    
    var selectedColor:String = "000000" {
        didSet {
            self.colorBtn.backgroundColor = UIColor.haxString(hex: selectedColor)
            self.drawContext.changeBrushColor(color: selectedColor)
        }
    }
    
    var fontSize:CGFloat = 13.0 {
        didSet {
            self.drawContext.changeBrushSize(size: fontSize)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "画板"
        updateUI()
        self.bgImage.image = UIImage(named:"qupu")
        segment.addTarget(self, action: #selector(segmentValueChanged), for: .valueChanged)
        segment.selectedSegmentIndex = 0 //默认就是画曲线的画笔
        segmentValueChanged(seg: segment)
    }
    
    func updateUI(){
        self.backBtn.layer.cornerRadius = 4
        self.backBtn.layer.masksToBounds = true
        self.forwardBtn.layer.cornerRadius = 4
        self.forwardBtn.layer.masksToBounds = true
        self.colorBtn.layer.cornerRadius = 4
        self.colorBtn.layer.masksToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.drawContext.hasDraw {
            self.drawContext.restoreDraw()
        }else{
            //从xml中读取
        }
    }

    //复原 减笔画
    @IBAction func backoutSelected(_ sender: Any) {
        if self.drawContext.canBack() {
            drawContext.undo()
        }
    }
    
    //重做 加笔画
    @IBAction func redrawSelected(_ sender: Any) {
        if self.drawContext.canForward() {
            drawContext.redo()
        }
    }
    
    //换颜色
    @IBAction func colorBtnClicked(_ sender: Any) {
        if segment.selectedSegmentIndex == 4 {
            return
        }
        showColorPick()
    }
    
    //调整画笔大小
    @IBAction func fontSizeChanged(_ sender: Any) {
        fontSize = CGFloat((sender as! UISlider).value)
    }
    
    func segmentValueChanged(seg:UISegmentedControl){
        if seg.selectedSegmentIndex == 2 {
            self.drawContext.showTextVIewUIMsg()
        }else{
            self.drawContext.hideTextViewUIMsg()
        }
        switch seg.selectedSegmentIndex {
        case 0:
            //画笔
            self.drawContext.initBrush(type: .Pentype(.Curve), color: selectedColor, width: fontSize)
            break
        case 1:
            //形状,先默认是矩形
            self.drawContext.initBrush(type: .Formtype(.Rect), color: selectedColor, width: fontSize)
            break
        case 2:
            //文本
            self.drawContext.initBrush(type: .Text, color: selectedColor, width: fontSize)
            break
        case 3:
            //音符，当作文字来添加
            self.drawContext.initBrush(type: .Note, color: selectedColor, width: fontSize)
            break
        case 4:
            //橡皮擦,不需要选颜色
            self.drawContext.initBrush(type: .Eraser, color: selectedColor, width: fontSize)
            break
        default:
            break
        }
    }
    
    //选完颜色和大小
    func showColorPick() {
        let color = ColorPicker.init { (colorStr) in
            self.selectedColor = colorStr
        }
        color.view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        color.definesPresentationContext = true
        color.modalPresentationStyle = .overCurrentContext
        self.present(color, animated: false, completion: nil)
    }
    
    deinit {

    }
    
}


extension Quartz2DTestController{
    //将xml的操作顺序放进数组里
    func getDataFromXML(){
        
    }
    
    //将全局数组里的数据按画画顺序存进xml文本中
    func saveDrawToXML(){
        
    }
}


//备用
//extension Quartz2DTestController{
//    func getCacheImg(index:Int)->UIImage?{
//        let userdefault = UserDefaults.standard
//        if let contexts = userdefault.array(forKey: "contexts") {
//            if index >= contexts.count {
//                self.currentIndex = contexts.count - 1
//                let imgD = contexts[currentIndex] as! Data
//                let img = NSKeyedUnarchiver.unarchiveObject(with: imgD) as! UIImage
//                return img
//            }else if index >= 0 { //index < contexts.count &&
//                let imgD = contexts[index] as! Data
//                let img = NSKeyedUnarchiver.unarchiveObject(with: imgD) as! UIImage
//                return img
//            }else {
//                self.currentIndex = -1
//            }
//        }
//        return nil
//    }
//    
//    func fu(){
//        let userdefault = UserDefaults.standard
//        if let contexts = userdefault.array(forKey: "contexts") {
//            self.currentIndex = contexts.count - 1 //把当前定义为最后一张图
////            self.imgView.image = self.getCacheImg(index: self.currentIndex)
//        }
//        
//        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIApplicationDidEnterBackground, object: nil, queue: OperationQueue.main) { (notification) in
//            //程序进入后台，就把缓存里的笔画存为当前的笔画，之前被回撤的笔画就会消失掉
//            let userdefault = UserDefaults.standard
//            if let contexts = userdefault.array(forKey: "contexts") {
//                var contextArr = contexts
//                if self.currentIndex < 0{
//                    userdefault.set(nil, forKey: "contexts")
//                }else if self.currentIndex < contexts.count && self.currentIndex >= 0 {
//                    let n = contextArr.count - (self.currentIndex + 1)
//                    contextArr.removeLast(n) //移除最后n个元素
//                    userdefault.set(contextArr, forKey: "contexts")
//                }
//            }
//            
//        }
//    }
//}

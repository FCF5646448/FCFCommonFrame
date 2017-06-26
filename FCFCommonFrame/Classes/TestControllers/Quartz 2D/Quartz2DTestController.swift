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
    
    var currentIndex:Int = -1 //笔画缓存的下标，-1表示没有缓存
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "画板"
        self.bgImage.image = UIImage(named:"qupu")
        segment.addTarget(self, action: #selector(segmentValueChanged), for: .touchUpInside)
        segment.selectedSegmentIndex = 0 //默认就是画曲线的画笔
        segmentValueChanged(seg: segment)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    //复原 减笔画
    @IBAction func backoutSelected(_ sender: Any) {
        
    }
    
    //重做 加笔画
    @IBAction func redrawSelected(_ sender: Any) {
        
    }
    
    func segmentValueChanged(seg:UISegmentedControl){
        switch seg.selectedSegmentIndex {
        case 0:
            //画笔
            drawContext.initBrush(type: .Pentype(.Curve), color: MainColor, width: 3.0)
            break
        case 1:
            //形状
            
            break
        case 2:
            //文本
            
            break
        case 3:
            //音符
            
            break
        case 4:
            //橡皮擦
            
            break
        default:
            break
        }
    }
    
    deinit {
//        NotificationCenter.default.removeObserver(self)
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
extension Quartz2DTestController{
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
    
    func fu(){
        let userdefault = UserDefaults.standard
        if let contexts = userdefault.array(forKey: "contexts") {
            self.currentIndex = contexts.count - 1 //把当前定义为最后一张图
//            self.imgView.image = self.getCacheImg(index: self.currentIndex)
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
}

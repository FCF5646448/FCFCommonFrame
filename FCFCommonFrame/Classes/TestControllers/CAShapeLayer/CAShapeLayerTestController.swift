//
//  CAShapeLayerTestController.swift
//  FCFCommonFrame
//
//  Created by 冯才凡 on 2017/6/21.
//  Copyright © 2017年 com.fcf. All rights reserved.
//

import UIKit


var drawArray:[String:AnyObject] = [:] //全局存放画的任何东西

class CAShapeLayerTestController: BaseViewController {
    
    @IBOutlet weak var segment: UISegmentedControl!
    
    @IBOutlet weak var bgImg: UIImageView!
    
    @IBOutlet weak var drawLayer: DrawLayerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "CAShapeLayer的基本使用"
        
        
    }
    
    func loadUI(){
        self.bgImg.image = UIImage(named:"qupu")
        segment.addTarget(self, action: #selector(segmentSelectedChanged), for: .valueChanged)
        segment.selectedSegmentIndex = 0
        segmentSelectedChanged(sender: segment)
        
        let btn = UIButton.init(type: .custom)
        btn.frame = CGRect.init(x: 0, y: 0, width: 60, height: 40)
        btn.setTitle("保存", for: .normal)
        btn.addTarget(self, action: #selector(saveDrawToXML), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: btn)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func segmentSelectedChanged(sender:UISegmentedControl){
        switch sender.selectedSegmentIndex {
        case 0:
            print("铅笔")
            drawLayer.didSelectPen(linewidth: 3, strokecolor: UIColor.red.cgColor, penType: .Curve)
        case 1:
            print("音符")
        case 2:
            print("形状")
            
        case 3:
            print("文本")
        case 4:
            print("橡皮擦")
        default:
            break
        }
    }
    
    //撤销最后一笔
    @IBAction func backBtnClicked(_ sender: Any) {
        
    }
    
    //重新把刚才撤销的笔画画上去
    @IBAction func forwardBtnClicked(_ sender: Any) {
        
    }
}

extension CAShapeLayerTestController{
    //从XML文件中加载数据
    func loadDrawFromText(){
//        let userDefault = UserDefaults.standard
//        if let index:Int = userDefault.integer(forKey: "Current"){
//            if let pointStr = self.getMutablePointStr(index: index){
//                var pointArr:[String] = pointStr.components(separatedBy: "^")
//                for str in pointArr {
//                    let point:CGPoint = CGPointFromString(str)
//                }
//            }
//            
//        }
    }
    
    //从userdefault中获取这个笔画的
    func getMutablePointStr(index:Int)->NSMutableString?{
        let userDefault = UserDefaults.standard
        if let pointStrArr:[NSMutableString] = userDefault.array(forKey: "pointStrArr") as? [NSMutableString]{
            if index < pointStrArr.count {
                let pointStr:NSMutableString = pointStrArr[index]
                return pointStr
            }
            return nil
        }
        return nil
    }
    
    //将画的所有的东西按原始顺序存到xml文件中
    func saveDrawToXML(){
        
    }
    
    func loadXML(){
        //从服务器加载xml文件，将文件存到本地
        //从本地加载xml文件
        
    }
}



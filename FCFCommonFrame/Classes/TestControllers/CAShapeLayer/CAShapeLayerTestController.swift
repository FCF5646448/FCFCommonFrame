//
//  CAShapeLayerTestController.swift
//  FCFCommonFrame
//
//  Created by 冯才凡 on 2017/6/21.
//  Copyright © 2017年 com.fcf. All rights reserved.
//

import UIKit

var DrawArray:[(type:DrawShapeType,colorStr:String,strokeWidth:CGFloat,points:[CGPoint])] = [] //全局存放类型、颜色值(十六进制颜色值)、画笔宽度、点s！
var currentIndex:Int = 0 //DrawShapeType.count

class CAShapeLayerTestController: BaseViewController {
    
    @IBOutlet weak var bgImg: UIImageView!
    
    @IBOutlet weak var drawLayer: DrawLayerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "CAShapeLayer的基本使用"
        loadUI()
    }
    
    func loadUI(){
        self.bgImg.image = UIImage(named:"qupu")
        drawLayer.didSelectPen(linewidth: 3, strokecolor: "000000", penType: .Curve)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if DrawArray.count > 0 {
            //先找本地有木有，没有就找内存的
            currentIndex = DrawArray.count
            drawFromDrawArray(index:currentIndex)
        }
    }
    
    //撤销最后一笔
    @IBAction func backBtnClicked(_ sender: Any) {
        if currentIndex > 0 {
            currentIndex -= 1
            drawFromDrawArray(index:currentIndex)
        }else{
            currentIndex = 0
        }
    }
    
    //重新把刚才撤销的笔画画上去
    @IBAction func forwardBtnClicked(_ sender: Any) {
        if currentIndex+1 <= DrawArray.count {
            currentIndex += 1
            drawFromDrawArray(index:currentIndex)
        }else{
            currentIndex = DrawArray.count
        }
    }
}

extension CAShapeLayerTestController{
    
    //将DrawArray里的内容画到画布上去
    func drawFromDrawArray(index:Int){
        //先将画布清空
        drawLayer.ifSavePoint = false
        for i in 0..<DrawArray.count {
            let item = DrawArray[i]
            switch item.type {
            case .Curve:
                //曲线
                
                var colorStr = item.colorStr
                if i >= index  {
                    //无色
                    colorStr = MainColor //会把颜色冲掉
                }
                drawLayer.didSelectPen(linewidth: item.strokeWidth, strokecolor: colorStr, penType: .Curve)
                var i = 0
                for point in item.points {
                    if i == 0 {
                        drawLayer.addPoint(point: point, state: .begin)
                    }else if i == item.points.count - 1 {
                        drawLayer.addPoint(point: point, state: .ended)
                    }else{
                        drawLayer.addPoint(point: point, state: .moved)
                    }
                    
                    i += 1
                }
                break
            case .Line:
                break
            case .Ellipse:
                break
            case .Rect:
                break
            case .Eraser:
                break
            case .Text:
                break
            case .Note:
                break
            }
        }
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
    
}



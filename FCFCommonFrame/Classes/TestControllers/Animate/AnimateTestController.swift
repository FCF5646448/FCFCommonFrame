//
//  AnimateTestController.swift
//  FCFCommonFrame
//
//  Created by 冯才凡 on 2017/6/8.
//  Copyright © 2017年 com.fcf. All rights reserved.
//

import UIKit

class AnimateTestController: BaseViewController {

    var dimension:Int = 4 //游戏方格维度 
    var width:CGFloat = 50 //数字格子的宽度
    var padding:CGFloat = 6 //格子与格子之间的间距
    var backgrounds:[UIView] = [] //保存背景图数据
    
    var redView:UIView!
    var blueView:UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animateWithDuration()
        createView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}
//使用animateWithDuration实现动画
extension AnimateTestController{
    func animateWithDuration(){
        setupGameMap()
        playAnimation()
    }
    func setupGameMap(){
        var x:CGFloat = 50
        var y:CGFloat = 50
        for i in 0..<dimension {
            print(i)
            y = 50
            for _ in 0..<dimension {
                //初始化视图
                let background = UIView.init(frame: CGRect.init(x: x, y: y, width: width, height: width))
                background.backgroundColor = UIColor.darkGray
                self.view.addSubview(background)
                backgrounds.append(background)
                y += padding + width
            }
            x += padding + width
        }
    }
    
    func playAnimation(){
        for tile in backgrounds {
            //先将数字块大小置为原始尺寸的1/10
            tile.layer.setAffineTransform(CGAffineTransform(scaleX: 0.1,y: 0.1))
            //将块设置透明
//            tile.alpha = 0
            UIView.animate(withDuration: 1, delay: 0.01, options: [], animations: {
                                tile.layer.setAffineTransform(CGAffineTransform(rotationAngle: 90)) //旋转
                //                tile.layer.setAffineTransform(CGAffineTransform(scaleX: 1,y: 1))
            }, completion: { (finish) in
                //完成动画时，数字块复原
                                tile.layer.setAffineTransform(CGAffineTransform.identity)
//                
//                UIView.animate(withDuration: 1, animations: {
//                    tile.alpha = 1
//                })
            })
        }
    }
}

//使用beginAnimation和commitAnimation来实现动画
extension AnimateTestController{
    func createView(){
        redView = UIView.init(frame: CGRect.init(x: 50, y: 350, width: 50, height: 50))
        redView.backgroundColor = UIColor.red
        self.view.addSubview(redView)
        
        blueView = UIView.init(frame: CGRect.init(x: 250, y: 350, width: 50, height: 50))
        blueView.backgroundColor = UIColor.blue
        self.view.addSubview(blueView)
        
        let btn = UIButton.init(type: .custom)
        btn.frame = CGRect.init(x: 50, y: 500, width: ContentWidth-100, height: 50)
        btn.setTitle("animate", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.backgroundColor = UIColor.red
        btn.addTarget(self, action: #selector(beginAnimate), for: .touchUpInside)
        view.addSubview(btn)
        
    }
    
    func beginAnimate(){
        fadeout()
        fadein()
//
        move()
        size()
        
//        curlUp()
        size()
        flip()
    }
    
    //淡入动画 其实就是alpha的变化
    func fadein(){
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(2.0)
        redView.alpha = 1.0
        UIView.commitAnimations()
    }
    
    //淡出动画 
    func fadeout(){
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(2.0)
        redView.alpha = 0.0
        UIView.commitAnimations()
    }
    
    //移动动画
    func move(){
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(2.0)
        blueView.center = CGPoint.init(x: 350, y: 500)
        UIView.setAnimationCurve(UIViewAnimationCurve.easeOut) //设置动画相对速度
        UIView.commitAnimations()
    }
    
    //调整大小
    func size(){
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(2.0)
        blueView.frame = CGRect.init(x: 250, y: 350, width: 100, height: 100)
        UIView.commitAnimations()
    }
    
    //向上翻转
    func curlUp(){
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(3.0)
        UIView.setAnimationTransition(.curlUp, for: self.view, cache: true)
        self.view.exchangeSubview(at: 1, withSubviewAt: 0)
        UIView.commitAnimations()
    }
    
    //切换视图
    func flip(){
        UIView.beginAnimations("animation", context: nil)
        UIView.setAnimationDuration(2.0)
        UIView.setAnimationCurve(.easeInOut)
        UIView.setAnimationTransition(.flipFromLeft, for: self.view, cache: false)
        UIView.commitAnimations()
    }
    
}


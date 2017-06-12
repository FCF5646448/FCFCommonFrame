//
//  MotionViewController.swift
//  FCFCommonFrame
//
//  Created by 冯才凡 on 2017/5/17.
//  Copyright © 2017年 com.fcf. All rights reserved.
//

import UIKit
import CoreMotion

class MotionViewController: BaseViewController {
    let ball = UIImageView.init(image: UIImage.init(named: "ball"))
    let motionManager = CMMotionManager()
    var speedX:UIAccelerationValue = 0
    var speedY:UIAccelerationValue = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "加速传感器"
        motion()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension MotionViewController:UIAccelerometerDelegate{
    func motion(){
        
        ball.frame = CGRect.init(x: 0, y: 0, width: 50, height: 50)
        ball.center = view.center
        view.addSubview(ball)
        
        motionManager.accelerometerUpdateInterval = 1/60
        
        
        if motionManager.isAccelerometerAvailable {
            let queue = OperationQueue.current
            motionManager.startAccelerometerUpdates(to: queue!, withHandler: { (accelerometerData, error) in
                //动态设置小球位置
                self.speedX += accelerometerData!.acceleration.x
                self.speedY += accelerometerData!.acceleration.y
                var posX = self.ball.center.x + CGFloat(self.speedX)
                var posY = self.ball.center.y - CGFloat(self.speedY)
                //碰到框后反弹
                if posX < 0 {
                    posX = 0;
                    self.speedX *= -0.4
                }else if posX > self.view.bounds.size.width {
                    posX = self.view.bounds.size.width
                    self.speedX += -0.4
                }
                if posY < 0 {
                    posY = 0
                    self.speedY *= -0.5
                }else if posY > self.view.bounds.size.height{
                    posY = self.view.bounds.size.height
                    self.speedY *= -1.5
                }
                self.ball.center = CGPoint.init(x: posX, y: posY)
            })
        }
    }
    
}

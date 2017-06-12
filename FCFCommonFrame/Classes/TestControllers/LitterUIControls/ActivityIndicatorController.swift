//
//  ActivityIndicatorController.swift
//  FCFCommonFrame
//
//  Created by 冯才凡 on 2017/6/9.
//  Copyright © 2017年 com.fcf. All rights reserved.
//

import UIKit

class ActivityIndicatorController: BaseViewController {

    var activityIndicator:UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "加载动画"
        activityIndicator = UIActivityIndicatorView.init(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        activityIndicator.center = CGPoint.init(x: ContentWidth/2, y: ContentHeight/2)
        activityIndicator.size = CGSize.init(width: 100, height: 100)
        self.view.addSubview(activityIndicator)
        play()
        
        let tapSigle = UITapGestureRecognizer.init(target: self, action: #selector(stop))
        tapSigle.numberOfTapsRequired = 1
        tapSigle.numberOfTouchesRequired = 1
        activityIndicator.addGestureRecognizer(tapSigle)
        self.view.addGestureRecognizer(tapSigle)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func play(){
        activityIndicator.startAnimating()
    }
    
    func stop(){
        activityIndicator.stopAnimating()
    }
    
}



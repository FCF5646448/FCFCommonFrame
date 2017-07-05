//
//  CGBaseTestController.swift
//  FCFCommonFrame
//
//  Created by 冯才凡 on 2017/7/5.
//  Copyright © 2017年 com.fcf. All rights reserved.
//

import UIKit

class CGBaseTestController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Core Graphics应用场景"
        let cgview = CGView(frame: self.view.frame)
        self.view.addSubview(cgview)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

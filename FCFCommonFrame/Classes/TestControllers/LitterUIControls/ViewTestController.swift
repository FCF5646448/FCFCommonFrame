//
//  ViewTestController.swift
//  FCFCommonFrame
//
//  Created by 冯才凡 on 2017/5/31.
//  Copyright © 2017年 com.fcf. All rights reserved.
//

import UIKit

class ViewTestController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "图片半透明背景"
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "swift")!).withAlphaComponent(0.5)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

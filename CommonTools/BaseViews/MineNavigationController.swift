//
//  MineNavigationController.swift
//  FCFCommonTools
//
//  Created by 冯才凡 on 2017/4/6.
//  Copyright © 2017年 com.fcf. All rights reserved.
//

import UIKit

class MineNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.barTintColor = UIColor.haxString(hex: MainColor) //这个是设置bar背景色
        navigationBar.tintColor = UIColor.white //这个是设置返回按钮颜色
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white] // 这个是设置title颜色
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        viewController.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "", style: .done, target: self, action: nil)
        super.pushViewController(viewController, animated: animated)
    }

}

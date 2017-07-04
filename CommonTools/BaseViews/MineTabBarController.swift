//
//  MineTabBarController.swift
//  FCFCommonTools
//
//  Created by 冯才凡 on 2017/4/6.
//  Copyright © 2017年 com.fcf. All rights reserved.
//

import UIKit

class MineTabBarController: UITabBarController {
    
    var first:FirstController {
        return FirstController()
    }
    
    var second:SecondController {
        return SecondController()
    }
    
    var third:ThirdController {
        return ThirdController()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loadControllers()
    }
    
    func loadControllers() {
        let controllArr = [("基础","First_Selected","First_Unselected",first)] as [(String,String,String,BaseViewController)]  // [("基础","First_Selected","First_Unselected",first),("面试","Second_Selected","Second_Unselected",second),("算法","Third_Selected","Third_Unselected",third)] as [(String,String,String,BaseViewController)] //First，Second，Third
        
        for (name,selectedImg,UnselectedImg,controller) in controllArr {
            controller.tabBarItem = UITabBarItem(title: name, image: UIImage(named: UnselectedImg)?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: selectedImg)?.withRenderingMode(.alwaysOriginal))
            let nc:MineNavigationController = MineNavigationController()
            nc.addChildViewController(controller)
            controller.title = name
            self.addChildViewController(nc)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}

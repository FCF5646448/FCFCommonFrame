//
//  BaseViewController.swift
//  FCFCommonFrame
//
//  Created by 冯才凡 on 2017/4/13.
//  Copyright © 2017年 com.fcf. All rights reserved.
//

import UIKit
import MBProgressHUD
import SDWebImage
import Alamofire
import ObjectMapper


class BaseViewController: UIViewController {
    fileprivate lazy var hud:MBProgressHUD = {
        let hud = MBProgressHUD(view:self.view)
        return hud
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = UIRectEdge()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

//hud
extension BaseViewController:MBProgressHUDDelegate{
    
    func showdownLoading() {
        self.view.addSubview(hud)
        self.view.bringSubview(toFront: hud)
        hud.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapHideDownLoading)))
        hud.show(true)
    }
     func tapHideDownLoading() {
        self.perform(#selector(hidedownLoading(_:)), with: nil, afterDelay: 3)
    }
    func hidedownLoading(_:Int) {
        hidedownLoading()
    }
    func hidedownLoading() {
        hud.removeFromSuperViewOnHide = true
        hud.hide(true)
    }
    
    /**
     展示信息
     */
    func showMsg(_ msg:String) {
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.labelText = msg
        hud.mode = .text
        hud.show(true)
        hud.hide(true, afterDelay: 1.5)
        hud.removeFromSuperViewOnHide = true
    }
}

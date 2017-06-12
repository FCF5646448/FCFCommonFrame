//
//  AlertControllerTest.swift
//  FCFCommonFrame
//
//  Created by 冯才凡 on 2017/6/7.
//  Copyright © 2017年 com.fcf. All rights reserved.
//

import UIKit

class AlertControllerTest: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    @IBAction func alertBtnClicked(_ sender: Any) {
        let alert = UIAlertController.init(title: "alert", message: "alert格式", preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "sure", style: .default, handler: { (action) in
            
        }))
        alert.addAction(UIAlertAction.init(title: "cancel", style: .cancel, handler: { (action) in
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func actSheetBtnClicked(_ sender: Any) {
        let alert = UIAlertController.init(title: " actSheet", message: " actSheet格式", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction.init(title: "sure", style: .default, handler: { (action) in
            
        }))
        alert.addAction(UIAlertAction.init(title: "cancel", style: .cancel, handler: { (action) in
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func tfBtnClicked(_ sender: Any) {
        let alert = UIAlertController.init(title: "TextField", message: "TextField格式", preferredStyle: .alert) //必须是alert样式
        alert.addTextField { (tf) in
            tf.placeholder = "name"
        }
        alert.addTextField { (tf) in
            tf.placeholder = "age"
            tf.layer.borderColor = UIColor.red.cgColor
        }
        alert.addAction(UIAlertAction.init(title: "sure", style: .default, handler: { (action) in
            
        }))
        alert.addAction(UIAlertAction.init(title: "cancel", style: .cancel, handler: { (action) in
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func hintBtnClicked(_ sender: Any) {
        let alert = UIAlertController.init(title: "提示信息", message: nil, preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) { 
            self.presentedViewController?.dismiss(animated: false, completion: nil)
        }
    }
}

//
//  TextFieldtestController.swift
//  FCFCommonFrame
//
//  Created by 冯才凡 on 2017/6/9.
//  Copyright © 2017年 com.fcf. All rights reserved.
//

import UIKit

class TextFieldtestController: BaseViewController {

    @IBOutlet weak var tf: UITextField!
    
    @IBOutlet weak var btn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "textfield"
        btn.isEnabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func btnClicked(_ sender: Any) {
        
    }
}

extension TextFieldtestController:UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
        btn.isEnabled = newText.characters.count > 0
        return true
    }
}




//
//  WechatViewController.swift
//  FCFCommonFrame
//
//  Created by 冯才凡 on 2017/5/18.
//  Copyright © 2017年 com.fcf. All rights reserved.
//

import UIKit

class WechatViewController: BaseViewController {

    @IBOutlet weak var tableView: TableView!
    
    
    var chats:NSMutableArray!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var textfield: UITextField!
    @IBOutlet weak var bottomBgView: UIView!
    
    var me:UserInfo!
    var you:UserInfo!
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBAction func sendBtnClicked(_ sender: Any) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "微信聊天页面"
        sendBtn.layer.cornerRadius = 4.0
        sendBtn.layer.masksToBounds = true
        textfield.returnKeyType = .send
        createBaseData()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange), name: .UIKeyboardWillChangeFrame, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        IQKeyboardManager.sharedManager().enable = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        IQKeyboardManager.sharedManager().enable = true
    }
    
    func createBaseData(){
        self.tableView.fcfRegister(MsgTableViewCell.self)
        self.tableView.fcfRegister(TableHeaderViewCell.self)
        me = UserInfo()
        me.username = "Xiaoming"
        me.avatar = "xiaoming.png"
        you = UserInfo()
        you.username = "Xiaohua"
        you.avatar = "xiaohua.png"
        
        let zero = MessageItem.init(body: "最近去哪玩了？", user: you, date: Date(timeIntervalSinceNow:-90096400), mtype: .someone)
        
        let zero1 = MessageItem.init(body: "去了趟苏州，等下发照片给你", user: me, date: Date(timeIntervalSinceNow:-90086400), mtype: .mine)
        
        let first =  MessageItem(body:"你看这风景怎么样，我周末去苏州拍的！", user:me,  date:Date(timeIntervalSinceNow:-90000600), mtype:.mine)
        
        let second =  MessageItem(image:UIImage(named:"sz.png")!,user:me, date:Date(timeIntervalSinceNow:-90000290), mtype:.mine)
        
        let third =  MessageItem(body:"太赞了，我也想去那看看呢！",user:you, date:Date(timeIntervalSinceNow:-90000060), mtype:.someone)
        
        let fouth =  MessageItem(body:"嗯，下次我们一起去吧！",user:me, date:Date(timeIntervalSinceNow:-90000020), mtype:.mine)
        
        let fifth =  MessageItem(body:"三年了，我终究没能看到这个风景",user:you, date:Date(timeIntervalSinceNow:0), mtype:.someone)
        
        chats = NSMutableArray()
        chats.addObjects(from: [first,second, third, fouth, fifth, zero, zero1])
        self.tableView.chatDataSource = self
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func sendMessage(){
        if textfield.text != nil && textfield.text! != "" {
            let sender = textfield
            let thisChat = MessageItem.init(body: sender!.text!, user: me, date: Date(), mtype: .mine)
            let thatChat = MessageItem.init(body: "你说的是\(sender!.text!)", user: you, date: Date(), mtype: .someone)
            chats.add(thisChat)
            chats.add(thatChat)
            self.tableView.reloadData()
        }else{
            self.showMsg("内容不能为空")
        }
        textfield.text = ""
        textfield.resignFirstResponder()
    }
    
    //键盘改变
    func keyboardWillChange(_ notification:Notification){
        if let userInfo = notification.userInfo {
            let value = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue
            let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double
            let curve = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? UInt
            let frame = value?.cgRectValue
            let intersection = frame?.intersection(self.view.frame)
            
            UIView.animate(withDuration: duration!, delay: 0.0, options: UIViewAnimationOptions(rawValue:curve!), animations: { 
                self.bottomConstraint.constant = intersection!.height
            }, completion: nil)
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension WechatViewController:UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendMessage()
        return true
    }
}

extension WechatViewController:ChatDataSource{
    func rowsForChatTable(_ tableView: TableView) -> Int {
        return self.chats.count
    }
    func chatTableView(_ tableView: TableView, dataForRow row: Int) -> MessageItem {
        return chats[row] as! MessageItem
    }
}

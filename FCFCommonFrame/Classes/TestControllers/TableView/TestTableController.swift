//
//  TestTableController.swift
//  FCFCommonFrame
//
//  Created by 冯才凡 on 2017/5/23.
//  Copyright © 2017年 com.fcf. All rights reserved.
//

import UIKit


class TestTableController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var alldatas:Dictionary<Int,[String]> = [
        0:[String]([
            "UILabel",
            "UIButton"
            ]),
        1:[String]([
            "UIDatePicker",
            "UITableView"
            ])
    ]
    
    var headData = [
        "常用UI Control",
        "高级UI Control"
    ]
    
    var isediting:Bool = false
    let rightBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 40, height: 24))
    
    var headerLabel:UILabel = {
        let label = UILabel.init(frame: CGRect.init(x: 0, y: 0, width:UIScreen.main.bounds.size.width, height: 49))
        label.textAlignment = .left
        label.text = "tableHeaderView和HeaderInSection是两个不一样的东西"
        label.backgroundColor = UIColor.purple
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "tableView增删"
        tableView.fcfRegister(BaseTableViewCell.self)
        tableView.tableHeaderView = headerLabel
        
        rightBtn.setTitle("编辑", for: .normal)
        rightBtn.addTarget(self, action: #selector(rightBtnClicked), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: rightBtn)
    }
    
    func rightBtnClicked(){
        if isediting {
            self.tableView.setEditing(false, animated: false)
            rightBtn.setTitle("编辑", for: .normal)
            isediting = false
        }else{
            self.tableView.setEditing(true, animated: true)
            rightBtn.setTitle("取消", for: .normal)
            isediting = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    //滚动到最后一行
    func scrollToBottom1(){
        let secon = 1 //最后一个分组的索引
        let rows = 0 //最后分组里的最后一条索引
        let indexPath = IndexPath.init(row: rows, section: secon)
        self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
    func scrollToBottom2(){
        let offset = CGPoint.init(x: 0, y: self.tableView.contentSize.height - self.tableView.bounds.size
        .height)
        self.tableView.setContentOffset(offset, animated: true)
    }
}



extension TestTableController:UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView:UITableView,numberOfRowsInSection section:Int)->Int{
        return self.alldatas[section]!.count + 1
    }
    
    func tableView(_ tableView:UITableView,titleForHeaderInSection section:Int)->String?{
        return self.headData[section]
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return "有\(self.alldatas[section]!.count)个标签"
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    //
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 24
    }
    
    //
    func tableView(_ tableView:UITableView, cellForRowAt indexPath:IndexPath)->UITableViewCell{
        let cell = self.tableView.fcfDequeueReusableCell(forIndexPath: indexPath) as BaseTableViewCell
        if indexPath.row == self.alldatas[indexPath.section]?.count {
            cell.textLabel?.text = "添加新数据..."
        }else{
            cell.textLabel?.text = self.alldatas[indexPath.section]?[indexPath.row]
        }
        
        return cell
    }
    //设置单元格的编辑状态
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        if indexPath.row == self.alldatas[indexPath.section]?.count {
            return .insert
        }else{
            return .delete
        }
    }
    
    //设置删除按钮的文字
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除"
    }
    
    //单元格编辑后的响应
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.alldatas[indexPath.section]?.remove(at: indexPath.row)
            tableView.reloadData()
            self.rightBtn.setTitle("编辑", for: .normal)
            tableView.setEditing(false, animated: false)
        }else if editingStyle == .insert{
            let alert = UIAlertController.init(title: "插入数据", message: "请输入名字", preferredStyle: .alert)
            alert.addTextField(configurationHandler: { (textField) in
                textField.placeholder = "名称"
            })
            alert.addAction(UIAlertAction.init(title: "确定", style: .default, handler: { (action) in
                let tf  = alert.textFields![0] as UITextField
                self.alldatas[indexPath.section]?.insert(tf.text!, at: indexPath.row)
                tableView.reloadData()
                self.rightBtn.setTitle("编辑", for: .normal)
                tableView.setEditing(false, animated: false)
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    //在cell将要显示的是你设置cell动画
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.layer.transform = CATransform3DMakeScale(0.1, 0.1,1)
        UIView.animate(withDuration: 0.25) { 
            cell.layer.transform = CATransform3DMakeScale(1, 1, 1)
        }
    }
}





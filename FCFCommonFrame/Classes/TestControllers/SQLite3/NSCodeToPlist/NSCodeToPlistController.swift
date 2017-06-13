//
//  NSCodeToPlistController.swift
//  FCFCommonFrame
//
//  Created by 冯才凡 on 2017/6/12.
//  Copyright © 2017年 com.fcf. All rights reserved.
//

import UIKit

class NSCodeToPlistController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var list:[NSCodeDataModel] = []
    var data:[NSCodeDataModel] = []
    var rightBtn:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "数据存到plist"
        tableView.fcfRegister(BaseTableViewCell.self)
        tableView.tableFooterView = UIView()
        createRightBtn()
        createTestData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createRightBtn(){
        rightBtn = UIButton.init(type: .custom)
        rightBtn.frame = CGRect.init(x: 0, y: 0, width: 40, height: 40)
        rightBtn.setTitle("保存", for: .normal)
        rightBtn.setTitleColor(UIColor.white, for: .normal)
        rightBtn.addTarget(self, action: #selector(rightBtnClicked), for: .touchUpInside)
        let rightBarBtn = UIBarButtonItem.init(customView: rightBtn)
        navigationItem.rightBarButtonItem = rightBarBtn
    }
    
    func rightBtnClicked(){
        if data.count > 0 {
            rightBtn.setTitle("加载", for: .normal)
            save()
        }else{
            load()
            rightBtn.setTitle("保存", for: .normal)
        }
    }
    
    func createTestData(){
        list.append(NSCodeDataModel(name: "张三", phone: "123456"))
        list.append(NSCodeDataModel(name: "李四", phone: "123456"))
        list.append(NSCodeDataModel(name: "赵武", phone: "123456"))
        list.append(NSCodeDataModel(name: "周六", phone: "123456"))
    }
    
    //创建路径
    func path()->String{
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentDirectory = paths.first
        let pathFile = documentDirectory?.appendingFormat("/userList.plist")
        return pathFile!
    }
    
    func save(){
        self.data.removeAll()
        self.tableView.reloadData()
        let data = NSMutableData()
        //声明一个归档对象
        let archiver = NSKeyedArchiver(forWritingWith: data)
        archiver.encode(list, forKey: "userList")
        archiver.finishEncoding()
        data.write(toFile: path(), atomically: true)
    }
    
    func load(){
        //
        let path = self.path()
        let defaultManager = FileManager() //拿到文件句柄
        if defaultManager.fileExists(atPath: path) {
            let url = URL.init(fileURLWithPath: path)
            let data = try! Data.init(contentsOf: url)
            //解码
            let unarchive = NSKeyedUnarchiver.init(forReadingWith: data)
            self.data = unarchive.decodeObject(forKey: "userList") as! [NSCodeDataModel]
            unarchive.finishDecoding()
            self.tableView.reloadData()
            
            //每一次加载完成后就删掉
            try! defaultManager.removeItem(atPath: path)
        }
    }
}

class NSCodeDataModel: NSObject,NSCoding {
    var name:String = ""
    var phone:String = ""
    required init(name:String="",phone:String = "") {
        self.name = name
        self.phone = phone
    }
    required init?(coder aDecoder: NSCoder) {
        self.name = aDecoder.decodeObject(forKey: "Name") as? String ?? ""
        self.phone = aDecoder.decodeObject(forKey: "Phone") as? String ?? ""
    }
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "Name")
        aCoder.encode(phone, forKey: "Phone")
    }
}

extension NSCodeToPlistController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.fcfDequeueReusableCell(forIndexPath: indexPath) as BaseTableViewCell
        cell.textLabel?.text = String.init(format: "%@:%@", data[indexPath.row].name,data[indexPath.row].phone)
        return cell
    }
}



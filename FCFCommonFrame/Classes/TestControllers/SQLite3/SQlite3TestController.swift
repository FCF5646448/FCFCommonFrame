//
//  SQlite3TestController.swift
//  FCFCommonFrame
//
//  Created by 冯才凡 on 2017/6/2.
//  Copyright © 2017年 com.fcf. All rights reserved.
//

import UIKit

//优秀的第三方 stephencelis/SQLite.swift
class SQlite3TestController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!

    var db:FCFSQLiteManager?

    var data:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "sqlite3原生操作(失败)"
        createRightBtn()
        tableView.tableFooterView = UIView()
        tableView.fcfRegister(BaseTableViewCell.self)
        createdb()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func createRightBtn(){
        let btn = UIButton.init(type: .contactAdd)
        btn.frame = CGRect.init(x: 0, y: 0, width: 40, height: 40)
        btn.addTarget(self, action: #selector(addItem), for: .touchUpInside)
        let rightBarBtn = UIBarButtonItem.init(customView: btn)
        self.navigationItem.rightBarButtonItem = rightBarBtn
    }
    
    func addItem(){
        let alert = UIAlertController.init(title: "添加数据", message: "请输入姓名和身高", preferredStyle: .alert)
        alert.addTextField { (tf) in
            tf.placeholder = "请输入姓名(必填)"
        }
        alert.addTextField { (tf) in
            tf.placeholder = "请输入身高(必填)"
        }
        alert.addAction(UIAlertAction.init(title: "确定", style: .default, handler: { (action) in
            let nametf = alert.textFields![0] as UITextField
            let heighttf = alert.textFields![1] as UITextField
            if nametf.text != "" && heighttf.text != ""{
                self.insert(name: nametf.text!, height: heighttf.text!)
            }else{
                self.showMsg("请填写必填信息")
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

//数据库操作
extension SQlite3TestController{
    //创建数据库,同时创建一个students表，有名字和身高字段
    func createdb(){
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let sqlitePath = urls[urls.count - 1].absoluteString + "sqlite3.db"
        print(sqlitePath)
        db = FCFSQLiteManager(path: sqlitePath)
        if let mydb = db {
            //create table
            let _ = mydb.creatTable("students", columsInfo: [
                "id integer primary key autoincrement",
                "name text",
                "height double"])
        }
    }
    
    //插入数据
    func insert(name:String,height:String){
        if let mydb = db {
            //insert
            let n = String.init(format: "'%@'", name)
            if mydb.insert("studentds", rowInfo: ["name":n,"height":height]) {
                select()
            }
        }
    }
    
    //查找全部
    func select(){
        if let mydb = db {
            self.data.removeAll()
            let statement = mydb.fetch("students", cond: "1 == 1", order: nil)
            while sqlite3_step(statement) == SQLITE_ROW {
                let id = sqlite3_column_int(statement, 0)
                let name = String.init(cString: sqlite3_column_text(statement, 1))
                let height = sqlite3_column_double(statement, 2)
                let str = String.init(format: "ID:%@; Name:%@; 身高:%@", id,name,height)
                self.data.append(str)
            }
            sqlite3_finalize(statement)
            self.tableView.reloadData()
        }
    }
    
    //固定更新该数据的名称
    func update(name:String,height:String,id:Int){
        if let mydb = db {
            let cond = String.init(format: "id = %@", id)
            let _ = mydb.update("students", cond: cond,rowInfo: ["name":"'\(name)'","height":height])
        }
    }
    
    //删除第一条数据
    func delete(id:Int) {
        if let mydb = db {
            let cond = String.init(format: "id = %@", id)
            let _ = mydb.delete("students", cond: cond)
        }
    }
}

extension SQlite3TestController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.fcfDequeueReusableCell(forIndexPath: indexPath) as BaseTableViewCell
        cell.textLabel?.text = self.data[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}



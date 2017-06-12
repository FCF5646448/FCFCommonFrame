//
//  SqliteDBSwiftController.swift
//  FCFCommonFrame
//
//  Created by 冯才凡 on 2017/6/6.
//  Copyright © 2017年 com.fcf. All rights reserved.
//

import UIKit

class SqliteDBSwiftController: BaseViewController {
    
    var db:SQLiteDB! //使用这个库除了要引进libsqlite3.tbd外，还有一个关键的就是要手动创建一个data.db数据库。

    @IBOutlet weak var img: UIImageView!
    
    @IBOutlet weak var accountTf: UITextField!
    
    @IBOutlet weak var phoneNumTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "SQLiteDB使用"
        createDB()
        fetch()
        
        /*let sql = "drop table t_user"
        let result = db.execute(sql:sql)
        print(result)*/
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveBtnClicked(_ sender: Any) {
        self.view.endEditing(true) //这是黑科技呀。无论页面上有多少个textfield，不需要去判断当前是哪个获取的焦点，直接可以通过这个方法收起键盘
        if accountTf.text != "" && phoneNumTF.text != "" {
            save()
        }else{
            showMsg("请填写完整信息")
        }
    }
    
}

extension SqliteDBSwiftController{
    func createDB(){
        db = SQLiteDB.shared //获取数据库实例
        _  = db.openDB() //打开数据库
        //如果表还不存在就创建表(uid自增)
        let result = db.execute(sql: "create table if not exists t_user(uid integer primary key,uname varchar(20),mobile varchar(20),imgData blob)") //用于保存Data数据的字段要使用大数据类型，比如blob(二进制)
        print(result)
        //加载数据库数据
        
    }
    //从SQLite加载数据
    func fetch(){
        let data = db.query(sql: "select * from t_user")
        if data.count > 0 {
            //获取最后一行数据
            let user = data[data.count - 1]
            accountTf.text = user["uname"] as? String
            phoneNumTF.text = user["mobile"] as? String
            if let imgData = user["imgData"] as? Data {
                self.img.image = UIImage(data: imgData)
            }
        }
    }
    
    //保存数据到SQLite
    func save(){
        let uname = accountTf.text!
        let mobile = phoneNumTF.text!
        let imagedata:Data = UIImagePNGRepresentation(UIImage.init(named: "BROOK")!)! //注意这个imge转data的方法
        //查找如果有这个名字就更新
        let sql = "select * from t_user where uname = '\(uname)'"
        let result = db.query(sql: sql)
        if result.count > 0 {
            //存在,更新
            let sql = "update t_user set mobile = '\(mobile)' where uname = '\(uname)'"
            let result = db.execute(sql: sql)
            print(result)
        }else{
            //插入语句
            let sql = "insert into t_user(uname,mobile,imgData) values('\(uname)','\(mobile)',?)"
            print(sql)
            //执行
            let result = db.execute(sql: sql,parameters: [imagedata])
            print(result)
        }
    }
}

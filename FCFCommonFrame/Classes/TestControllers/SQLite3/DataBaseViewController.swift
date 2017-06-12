//
//  DataBaseViewController.swift
//  FCFCommonFrame
//
//  Created by 冯才凡 on 2017/6/6.
//  Copyright © 2017年 com.fcf. All rights reserved.
//

import UIKit

class DataBaseViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var data:[String] = ["UserDefaults使用","NSCode将对象存储到plist文件","sqlite3原生","SQLiteDB.swift(3)","stephencelis/SQLite.swift(3)(NotLearn)","Realm(NotLearn)"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "数据存储相关"
        tableView.tableFooterView = UIView()
        tableView.fcfRegister(BaseTableViewCell.self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

extension DataBaseViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.fcfDequeueReusableCell(forIndexPath: indexPath) as BaseTableViewCell
        cell.textLabel?.text = data[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch data[indexPath.row] {
        case "UserDefaults使用":
            let vc = UserDefaultTestController()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        case "sqlite3原生":
            let vc = SQlite3TestController()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        case "SQLiteDB.swift(3)":
            let vc = SqliteDBSwiftController()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
}

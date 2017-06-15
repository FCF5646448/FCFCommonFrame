//
//  InterviewTestController.swift
//  FCFCommonFrame
//
//  Created by 冯才凡 on 2017/6/8.
//  Copyright © 2017年 com.fcf. All rights reserved.
//

import UIKit

class InterviewTestController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!

    var data = ["内存泄露(循环强引用)","多线程",""] //网站
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        tableView.fcfRegister(BaseTableViewCell.self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension InterviewTestController:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.fcfDequeueReusableCell(forIndexPath: indexPath) as BaseTableViewCell
        cell.textLabel?.text = data[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch data[indexPath.row] {
        case "内存泄露(循环强引用)":
            break
        default:
            break
        }
    }
}



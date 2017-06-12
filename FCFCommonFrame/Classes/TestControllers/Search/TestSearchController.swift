//
//  TestSearchController.swift
//  FCFCommonFrame
//
//  Created by 冯才凡 on 2017/5/25.
//  Copyright © 2017年 com.fcf. All rights reserved.
//

import UIKit

/**UISearchController的使用*/
class TestSearchController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var dataArr:[String] = ["UILabel","UIButton","UIView","UITextField","UITextView","UISwitch","UISegmentControl","UIImageView","UIProgressView","UISlider","UIStepper","UIScrollView","UIPickerView","UIWebView","UIDatePicker","UIToolbar","UIActionSheet","UIAlertController","UISearchBar"]
    
    var searchController = UISearchController()
    
    var searchArr:[String] = [String](){
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "UISearchController的使用"
        tableView.tableFooterView = UIView()
        tableView.fcfRegister(BaseTableViewCell.self)
        
        self.searchController = {
            let controller = UISearchController(searchResultsController: nil)
//            controller.searchResultsUpdater = self //这个用于实时搜索
            controller.searchBar.delegate = self //点击搜索按钮之后才开始搜索，这个一般用于搜索不是本地数据的时候使用
            controller.hidesNavigationBarDuringPresentation = false
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.searchBarStyle = .minimal
            controller.searchBar.sizeToFit()
            self.tableView.tableHeaderView = controller.searchBar
            return controller
        }()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
}

extension TestSearchController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.searchController.isActive {
            return self.searchArr.count
        }else{
            return self.dataArr.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.fcfDequeueReusableCell(forIndexPath: indexPath) as BaseTableViewCell
        if self.searchController.isActive {
            cell.textLabel?.text = self.searchArr[indexPath.row]
        }else{
            cell.textLabel?.text = self.dataArr[indexPath.row]
        }
        return cell
    }
    
}

//extension TestSearchController:UISearchResultsUpdating{
//    //实时搜索
//    func updateSearchResults(for searchController: UISearchController) {
//        self.searchArr = self.dataArr.filter({ (str) -> Bool in
//            return str.contains(searchController.searchBar.text!)
//        })
//    }
//}

//点击按钮之后才搜索
extension TestSearchController:UISearchBarDelegate{
    //搜索按钮
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchArr = self.dataArr.filter({ (str) -> Bool in
            return str.contains(searchController.searchBar.text!)
        })
    }
    //取消按钮
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchController.isActive = false
        self.tableView.reloadData()
    }
}



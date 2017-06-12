//
//  BaseSearchController.swift
//  FCFCommonFrame
//
//  Created by 冯才凡 on 2017/5/24.
//  Copyright © 2017年 com.fcf. All rights reserved.
//

import UIKit

/**简单的SearchBar的使用*/
class BaseSearchController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    var searchActivity:Bool = false
    
    var baseData:[String] = ["UILabel","UIButton","UIView","UITextField","UITextView","UISwitch","UIActivity","UIActivityIndicator","UISegmentControl","UIImageView","UIProgressView","UISlider","UIStepper","UIPageControl","UIScrollView","UIPickerView","UIWebView","UIDatePicker","UIToolbar","UIActionSheet","UIAlertController","UISearchController"]
    var searchData:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "UI小控件"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.tableHeaderView = createSearchBar()
        tableView.fcfRegister(BaseTableViewCell.self)
    }
    
    func createSearchBar()->UIView{
        let searchBar = UISearchBar.init(frame: CGRect.init(x: 10, y: 0, width: self.tableView.width-20, height: 50))
        searchBar.delegate = self
        searchBar.returnKeyType = .search
        searchBar.placeholder = "请输入您要搜索的控件名称"
        customSearchStyle(sender: searchBar)
        return searchBar
    }
    
    //自定义searchBar的样式
    func customSearchStyle(sender:UISearchBar){
        sender.backgroundImage = UIImage()
        sender.barTintColor =  UIColor.clear
        for subview in sender.subviews[0].subviews {
            if subview.isKind(of: UITextField.self) {
                //获取textfield
                let searchField:UITextField = subview as! UITextField
                searchField.layer.cornerRadius = 4.0 //searchField.height/2.0
                searchField.layer.masksToBounds = true
                searchField.layer.borderWidth = 1.0
                searchField.layer.borderColor = UIColor.haxString(hex: MainColor).cgColor
            }
            
            if subview.isKind(of: UIButton.self) {
                let cancelBtn:UIButton = subview as! UIButton
                cancelBtn.setTitle("取消", for: .normal)
                cancelBtn.setTitleColor(UIColor.white, for: .normal)
                cancelBtn.layer.cornerRadius = 4.0
                cancelBtn.layer.masksToBounds = true
                cancelBtn.backgroundColor = UIColor.haxString(hex: MainColor)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}

extension BaseSearchController:UISearchBarDelegate{
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        print("begin") //开始输入
        searchActivity = true
        searchBar.setShowsCancelButton(true, animated: true)
        customSearchStyle(sender: searchBar)
        return true
    }
    //点击键盘里的搜索按钮触发
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        print("\(searchBar.text!)")
    }
    
    //点击取消按钮
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchActivity = false
        searchBar.setShowsCancelButton(false, animated: true)
        self.tableView.reloadData()
    }
    
    //输入的数据改变的时候
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        if searchText == "" {
            self.searchData = self.baseData
        }else{
            //实时搜索
            self.searchData = []
            for item in self.baseData {
                if item.lowercased().hasPrefix(searchText.lowercased()) {
                    self.searchData.append(item)
                }
            }
        }
        self.tableView.reloadData()
    }
}

extension BaseSearchController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.searchActivity {
             return searchData.count
        }
        return baseData.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.fcfDequeueReusableCell(forIndexPath: indexPath) as BaseTableViewCell
        if self.searchActivity{
            cell.textLabel?.text = searchData[indexPath.row]
        }else{
            cell.textLabel?.text = baseData[indexPath.row]
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        let str = cell?.textLabel?.text ?? ""
        switch str {
        case "UILabel":
            let vc = LabelTestController()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        case "UIView":
            let vc = ViewTestController()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        case "UITextField":
            let vc = TextFieldtestController()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        case "UIActivity":
            let vc = ActivityTestController()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        case "UIActivityIndicator":
            let vc = ActivityIndicatorController()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        case "UIScrollView":
            let vc = ScrollViewTestController()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        case "UIAlertController":
            let vc = AlertControllerTest()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        case "UISearchController":
            let search = TestSearchController()
            search.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(search, animated: true)
        case "UIPageControl":
            let vc = PageControlTestController()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
        
    }
}


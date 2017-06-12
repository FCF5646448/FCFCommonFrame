//
//  CollectViewDataController.swift
//  FCFCommonFrame
//
//  Created by 冯才凡 on 2017/5/26.
//  Copyright © 2017年 com.fcf. All rights reserved.
//

import UIKit

class CollectViewDataController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var data = ["UICollectionView简单布局","UICollectionView瀑布流复杂布局","UICollectionView分组","UICollectionView环形布局"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "CollectionView使用"
        tableView.tableFooterView = UIView()
        tableView.fcfRegister(BaseTableViewCell.self)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

}

extension CollectViewDataController:UITableViewDataSource,UITableViewDelegate{
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
        case "UICollectionView简单布局":
            let vc = CollectionViewController()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case "UICollectionView瀑布流复杂布局":
            let vc = CollectionViewPUBULIUController()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case "UICollectionView分组":
            
            break
        case "UICollectionView环形布局":
            
            break
        default:
            
            break
        }
    }
}

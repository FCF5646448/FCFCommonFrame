//
//  CollectionViewController.swift
//  FCFCommonFrame
//
//  Created by 冯才凡 on 2017/5/25.
//  Copyright © 2017年 com.fcf. All rights reserved.
//

import UIKit

//
class CollectionViewController: BaseViewController {

    @IBOutlet weak var collectionView: UICollectionView!

    var course = [(name:"Swift",pic:"swift"),(name:"Xcode",pic:"xcode"),(name:"Java",pic:"java"),(name:"PHP",pic:"php"),(name:"JS",pic:"js"),(name:"React",pic:"react"),(name:"Ruby",pic:"ruby"),(name:"HTML",pic:"html"),(name:"C#",pic:"c#")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "UICollectionView的简单使用"
        collectionView.fcfRegister(TestCollectionViewCell.self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}

extension CollectionViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return course.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.fcfDequeueReusableCell(forIndexPath: indexPath) as TestCollectionViewCell
        cell.imgView.image = UIImage.init(named:  course[indexPath.item].pic)
        cell.label.text = course[indexPath.item].name
        return cell
    }
}

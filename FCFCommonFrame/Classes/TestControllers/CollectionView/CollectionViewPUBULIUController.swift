//
//  CollectionViewPUBULIUController.swift
//  FCFCommonFrame
//
//  Created by 冯才凡 on 2017/5/26.
//  Copyright © 2017年 com.fcf. All rights reserved.
//

import UIKit

class CollectionViewPUBULIUController: BaseViewController {

    var collectionView:UICollectionView!
    
    var course = [(name:"Swift",pic:"swift"),(name:"Xcode",pic:"xcode"),(name:"Java",pic:"java"),(name:"PHP",pic:"php"),(name:"JS",pic:"js"),(name:"React",pic:"react"),(name:"Ruby",pic:"ruby"),(name:"HTML",pic:"html"),(name:"C#",pic:"c#"),(name:"Swift",pic:"swift"),(name:"Xcode",pic:"xcode"),(name:"Java",pic:"java"),(name:"PHP",pic:"php"),(name:"JS",pic:"js"),(name:"React",pic:"react"),(name:"Ruby",pic:"ruby"),(name:"HTML",pic:"html"),(name:"C#",pic:"c#")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = CustomLayout()
        let frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - 64 )
        self.collectionView = UICollectionView.init(frame: frame, collectionViewLayout: layout)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.fcfRegister(TestCollectionViewCell.self)
        collectionView.contentInset = UIEdgeInsets.init(top: 0, left: 5, bottom: 0, right: 5)
        self.view.addSubview(collectionView)
        collectionView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}

extension CollectionViewPUBULIUController:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return course.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.fcfDequeueReusableCell(forIndexPath: indexPath) as TestCollectionViewCell
        cell.imgView.image = UIImage.init(named: self.course[indexPath.row].pic)
        cell.label.text = self.course[indexPath.row].name
        return cell
    }
}

//自定义section布局，UICollectionView的显示效果几乎都由UICollectionViewLayout负责。UICollectionViewFlowLayout是Apple官方实现的流水布局效果。
class CustomLayout:UICollectionViewLayout{
    //内容总区域大小，不是可见区域
    override var collectionViewContentSize: CGSize{
        let width = collectionView!.bounds.size.width - collectionView!.contentInset.left - collectionView!.contentInset.right
        let height = CGFloat((collectionView!.numberOfItems(inSection: 0) + 1)/3 ) * (width / 3 * 2)
        return CGSize.init(width: width, height: height)
    }
    
    //UICollectionViewLayoutAttributes 存储着cell的位置、大小等属性，
    //所有单元格位置属性
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attributeArray = [UICollectionViewLayoutAttributes]()
        let cellCount = self.collectionView!.numberOfItems(inSection: 0)
        for i in 0..<cellCount {
            let indexPath = IndexPath.init(item: i, section: 0)
            let attribute = self.layoutAttributesForItem(at: indexPath)
            attributeArray.append(attribute!)
        }
        return attributeArray
    }
    
    //这个方法返回每一Item的布局属性，包括位置和大小
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        //当前单元格布局属性
        let attribute = UICollectionViewLayoutAttributes.init(forCellWith: indexPath)
        //单元格边长
        let largeCellSide = collectionViewContentSize.width / 3 * 2
        let smallCellSide = collectionViewContentSize.width / 3
        
        //当前行数，每行显示3个图片，1大2小
        let line:Int = indexPath.item / 3
        //当前行的y坐标
        let lineOriginY = largeCellSide * CGFloat(line)
        //右侧单元格x坐标，这里按左右对齐，所以中间空隙大
        let rightLargeX = collectionViewContentSize.width - largeCellSide
        let rightSmallX = collectionViewContentSize.width - smallCellSide
        
        //一共六种位置
        if indexPath.item % 6 == 0 {
            attribute.frame = CGRect.init(x: 0, y: lineOriginY, width: largeCellSide, height: largeCellSide)
        }else if indexPath.item % 6 == 1 {
            attribute.frame = CGRect.init(x: rightSmallX, y: lineOriginY, width: smallCellSide, height: smallCellSide)
        }else if indexPath.item % 6 == 2 {
            attribute.frame = CGRect.init(x: rightSmallX, y: lineOriginY + smallCellSide, width: smallCellSide, height: smallCellSide)
        }else if indexPath.item % 6 == 3 {
            attribute.frame = CGRect.init(x: 0, y: lineOriginY, width: smallCellSide, height: smallCellSide)
        }else if indexPath.item % 6 == 4 {
            attribute.frame = CGRect.init(x: 0, y: lineOriginY + smallCellSide, width: smallCellSide, height: smallCellSide)
        }else if indexPath.item % 6 == 5 {
            attribute.frame = CGRect.init(x: rightLargeX, y: lineOriginY, width: largeCellSide, height: largeCellSide)
        }
        return attribute
    }
}

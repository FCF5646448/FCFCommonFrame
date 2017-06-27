//
//  ColorPicker.swift
//  FCFCommonFrame
//
//  Created by 冯才凡 on 2017/6/27.
//  Copyright © 2017年 com.fcf. All rights reserved.
//

import UIKit

typealias selectedCallBack = (_ type:DrawType,_ colorStr:String,_ size:CGFloat)->()

class ColorPicker: UIViewController {

    @IBOutlet weak var collctionBg: UIView!
    @IBOutlet weak var colorView: UICollectionView!
    
    @IBOutlet weak var selectedBtn: UIButton!
    
    @IBOutlet weak var sureBtn: UIButton!
    
    @IBOutlet weak var slide: UISlider!
    
    var selectedColor:String = "000000"
    
    var callback:selectedCallBack?
    
    var colorData:[String] = []
    
    var brushtype:DrawType
    
    init(type:DrawType,selected:@escaping ((_ type:DrawType,_ colorStr:String,_ size:CGFloat)->())) {
        self.brushtype = type
        self.callback = selected
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        collctionBg.layer.cornerRadius = 4
        collctionBg.layer.masksToBounds = true
        selectedBtn.layer.cornerRadius = 4
        selectedBtn.layer.masksToBounds = true
        selectedBtn.backgroundColor = UIColor.haxString(hex: selectedColor)
        sureBtn.layer.cornerRadius = 4
        sureBtn.layer.masksToBounds = true
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 2
        layout.minimumLineSpacing = 2
        let iW:CGFloat = CGFloat(self.colorView.width - 9 * 2)
        let iH:CGFloat = CGFloat(self.colorView.height - 15 * 2) //- 44 - 26 - 65 - 16 -
        layout.itemSize = CGSize(width: iW/10, height: iH/16)
        layout.sectionInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        colorView.showsVerticalScrollIndicator = false
        colorView.showsHorizontalScrollIndicator = false
        colorView.isScrollEnabled = false
        colorView.collectionViewLayout = layout
        colorView.fcfRegister(BaseCollectionViewCell.self)
        
        slide.addTarget(self, action: #selector(slideValueChanged), for: .valueChanged)
        initColorData()
    }
    
    func initColorData(){
        
        let path = Bundle.main.path(forResource: "colorPalette", ofType: "plist")
        let plistArr = NSArray.init(contentsOfFile: path!)
        if let dataArr = plistArr {
            for item in dataArr {
                colorData.append(item as! String)
            }
        }
        colorView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func slideValueChanged(sender:UISlider){
        _ = sender.value
    }

    //确定
    @IBAction func sureBtnClicked(_ sender: Any) {
        self.callback!(self.brushtype,selectedColor,CGFloat(slide.value))
        self.dismiss(animated: false, completion: nil)
    }
    
}

extension ColorPicker:UICollectionViewDelegate,UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    //
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colorData.count
    }
    //
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.colorView.fcfDequeueReusableCell(forIndexPath: indexPath) as BaseCollectionViewCell
        cell.backgroundColor = UIColor.haxString(hex: colorData[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch self.brushtype {
        case .Eraser:
            let alert = UIAlertController.init(title: "橡皮擦无法选择颜色", message: "", preferredStyle: .alert)
            self.present(alert, animated: true, completion: nil)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2, execute: { 
                alert.dismiss(animated: false, completion: nil)
            })
            return
        default:
            break
        }
        let colorstr = self.colorData[indexPath.row]
        selectedColor = colorstr
        self.selectedBtn.backgroundColor = UIColor.haxString(hex: colorstr)
    }
}

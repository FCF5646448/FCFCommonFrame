//
//  TestCollectionViewCell.swift
//  FCFCommonFrame
//
//  Created by 冯才凡 on 2017/5/27.
//  Copyright © 2017年 com.fcf. All rights reserved.
//

import UIKit

class TestCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imgView: UIImageView!

    @IBOutlet weak var label: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        label.backgroundColor = UIColor.haxString(hex: "eeeeee").withAlphaComponent(0.2)
    }

}

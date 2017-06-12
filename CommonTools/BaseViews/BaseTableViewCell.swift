//
//  BaseTableViewCell.swift
//  FCFCommonFrame
//
//  Created by 冯才凡 on 2017/5/18.
//  Copyright © 2017年 com.fcf. All rights reserved.
//

import UIKit

class BaseTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

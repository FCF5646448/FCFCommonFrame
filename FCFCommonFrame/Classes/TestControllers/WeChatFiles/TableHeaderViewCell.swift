//
//  TableHeaderViewCell.swift
//  FCFCommonFrame
//
//  Created by 冯才凡 on 2017/5/19.
//  Copyright © 2017年 com.fcf. All rights reserved.
//

import UIKit

class TableHeaderViewCell: BaseTableViewCell {

    var iheight:CGFloat = 30.0
    var label:UILabel!
    
    class func getHeight()->CGFloat{
        return 30.0
    }
    
    func setDate(_ value:Date){
        iheight = 30.0
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy年MM月dd日"
        let text = dateFormatter.string(from: value)
        if label != nil{
            label.text = text
            return
        }
        label = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: self.frame.width, height: iheight))
        label.text = text
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textAlignment = .center
        label.shadowColor = UIColor.white
        label.shadowOffset = CGSize.init(width: 0, height: 1)
        label.textColor = UIColor.darkGray
        label.backgroundColor = UIColor.clear
        addSubview(label)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

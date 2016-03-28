//
//  UILabel+Extension.swift
//  xinlangweibo
//
//  Created by 刘朝阳 on 16/3/3.
//  Copyright © 2016年 刘朝阳. All rights reserved.
//

import UIKit

extension UILabel{

    //封装构造函数
    convenience init(textColor: UIColor, fontSize: CGFloat) {
        self.init()
        
        self.textColor = textColor
        self.font = UIFont.systemFontOfSize(fontSize)
    }
}

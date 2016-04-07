//
//  PassTimeCell.swift
//  ISSFriends
//
//  Created by Jacob Benton on 4/7/16.
//  Copyright © 2016 jakebent. All rights reserved.
//

import UIKit
import SnapKit

// This is just a small cell that displays a clock icon and a single pass time, for use in the FriendInfoExpandedView
class PassTimeCell: UIView {

    let iconView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "clock")
        return imageView
    }()
    let infoLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFontOfSize(12)
        return label
    }()

    init(passTime: String) {
        super.init(frame: CGRect.zero)
        addSubview(iconView)
        addSubview(infoLabel)

        iconView.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(snp_left).offset(12)
            make.centerY.equalTo(snp_centerY)
            make.height.equalTo(32)
            make.width.equalTo(iconView.snp_height)
        }
        infoLabel.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(iconView.snp_right).offset(12)
            make.right.equalTo(snp_right).offset(-12)
            make.centerY.equalTo(snp_centerY)
            make.height.equalTo(24)
        }

        infoLabel.text = passTime
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//
//  FriendInfoExpandedView.swift
//  ISSFriends
//
//  Created by Jacob Benton on 4/7/16.
//  Copyright © 2016 jakebent. All rights reserved.
//

import UIKit

// This is the view that is shown when a FriendInfoTableViewCell is expanded. It just shows the next three times the ISS will pass over this friend.
class FriendInfoExpandedView: UIView {
    var views = [PassTimeCell]()
    let passTimes: [String]

    init(passTimes: [String]) {
        self.passTimes = passTimes
        super.init(frame: CGRect.zero)
        clipsToBounds = true
    }

    func layoutViews() {
        if !views.isEmpty {
            for view in views {
                view.removeFromSuperview()
            }
            views = []
        }
        var previousView: UIView?
        for passTime in passTimes {
            let toggleCell = PassTimeCell(passTime: passTime)
            addSubview(toggleCell)
            toggleCell.snp_makeConstraints { (make) -> Void in
                make.left.equalTo(snp_left)
                make.right.equalTo(snp_right)
                make.height.equalTo(40)
                make.top.equalTo(previousView == nil ? snp_top : previousView!.snp_bottom)
            }
            previousView = toggleCell
            views.append(toggleCell)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
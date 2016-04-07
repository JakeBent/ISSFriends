//
//  Extensions.swift
//  ISSFriends
//
//  Created by Jacob Benton on 4/7/16.
//  Copyright © 2016 jakebent. All rights reserved.
//

import UIKit

extension UITableView {
    func registerCellClass(cellClass: UITableViewCell.Type) {
        registerClass(cellClass, forCellReuseIdentifier: NSStringFromClass(cellClass))
    }

    func dequeueCellClass<T>(cellClass: UITableViewCell.Type) -> T {
        return dequeueReusableCellWithIdentifier(NSStringFromClass(cellClass)) as! T
    }
}
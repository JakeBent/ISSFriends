//
//  FriendInfoTableViewCell.swift
//  ISSFriends
//
//  Created by Jacob Benton on 4/7/16.
//  Copyright © 2016 jakebent. All rights reserved.
//

import UIKit
import SnapKit
import Alamofire
import MapKit

// This is a table view cell displayed in the FriendsListViewController. It shows the name when collapsed and shows the name plus the next 3 pass times when expanded
class FriendInfoTableViewCell: UITableViewCell {
    static let CELL_HEIGHT: CGFloat = 40

    let background = UIView()
    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        return label
    }()
    let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        spinner.hidesWhenStopped = true
        return spinner
    }()
    let expandArrow: UIButton = {
        let button = UIButton()
        button.contentMode = .Right
        button.setImage(UIImage(named: "expand_arrow"), forState: .Normal)
        return button
    }()
    let divider: UIView = {
        let view = UIView()
        view.backgroundColor = .grayColor()
        return view
    }()
    weak var tableView: UITableView?
    var viewModel: FriendInfoViewModel?
    var expandedView: FriendInfoExpandedView?

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(background)
        contentView.addSubview(divider)
        background.addSubview(titleLabel)
        background.addSubview(expandArrow)
        background.addSubview(spinner)

        background.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(contentView.snp_left)
            make.right.equalTo(contentView.snp_right)
            make.top.equalTo(contentView.snp_top)
            make.height.equalTo(FriendInfoTableViewCell.CELL_HEIGHT)
        }
        divider.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(contentView.snp_left)
            make.right.equalTo(contentView.snp_right)
            make.bottom.equalTo(contentView.snp_bottom)
            make.height.equalTo(1)
        }
        titleLabel.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(background.snp_left).offset(12)
            make.centerY.equalTo(background.snp_centerY)
            make.right.equalTo(spinner.snp_left).offset(-12)
            make.height.equalTo(30)
        }
        expandArrow.snp_makeConstraints { (make) -> Void in
            make.centerY.equalTo(background.snp_centerY)
            make.right.equalTo(background.snp_right)
            make.width.equalTo(50)
        }
        spinner.snp_makeConstraints { (make) -> Void in
            make.centerY.equalTo(background.snp_centerY)
            make.right.equalTo(expandArrow.snp_left).offset(-12)
            make.width.equalTo(30)
            make.height.equalTo(30)
        }
        contentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "toggleCellExpansion"))
        expandArrow.addTarget(self, action: "toggleCellExpansion", forControlEvents: .TouchUpInside)
    }

    // When a cell/arrow is tapped either expand or collapse the cell
    func toggleCellExpansion() {
        guard let viewModel = viewModel else { return }
        viewModel.isExpanded ? collapseCell(animated: true) : expandCell(viewModel.friend.coordinate)
        viewModel.isExpanded = !viewModel.isExpanded
    }

    // Hide expanded view with pass times
    func collapseCell(animated animated: Bool = false) {
        guard let tableView = tableView else { return }

        tableView.beginUpdates()
        if animated {
            UIView.animateWithDuration(0.2, animations: { [weak self] () in
                self?.expandArrow.transform = CGAffineTransformMakeRotation(0)
            }) { [weak self] (_) in
                self?.expandedView?.removeFromSuperview()
                tableView.endUpdates()
            }
        } else {
            expandArrow.transform = CGAffineTransformMakeRotation(0)
            expandedView?.removeFromSuperview()
            tableView.endUpdates()
        }
    }

    // Call out to open-notify to retrieve pass times, then expand the cell when the data is returned
    func expandCell(coordinate: CLLocationCoordinate2D) {
        guard let tableView = tableView else { return }

        spinner.startAnimating()
        NetworkService.sharedService.getPassTimes(lat: coordinate.latitude, long: coordinate.longitude) { [weak self] (response) -> Void in

            self?.spinner.stopAnimating()

            guard let
                sself = self,
                value = response.result.value as? [String: AnyObject],
                result = value["response"] as? [[String: NSTimeInterval]]
                else { return }

            let times = result.flatMap({ (timeDict) -> String in
                guard let interval = timeDict["risetime"] else { return "" }
                return Utility.stringFromTimeInterval(interval)
            })

            tableView.beginUpdates()
            self?.expandedView = FriendInfoExpandedView(passTimes: times)
            self?.expandedView?.layoutViews()
            self?.contentView.insertSubview(sself.expandedView!, atIndex: 1)
            self?.expandedView?.snp_remakeConstraints { (make) -> Void in
                make.left.equalTo(sself.contentView.snp_left)
                make.right.equalTo(sself.contentView.snp_right)
                make.top.equalTo(sself.background.snp_bottom)
                make.bottom.equalTo(sself.contentView.snp_bottom)
            }
            UIView.animateWithDuration(0.2, animations: { [weak self] () in
                self?.expandArrow.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
            })
            tableView.endUpdates()
        }
    }

    // Called for every instance of this cell for initial setup and reuse
    func configure(viewModel: FriendInfoViewModel) {
        self.viewModel = viewModel
        viewModel.isExpanded ? expandCell(viewModel.friend.coordinate) : collapseCell()
        titleLabel.text = viewModel.friend.name
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

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
import Bond

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
    var friendObserver: DisposableType?
    var isExpandedObserver: DisposableType?
    var viewModel: FriendInfoViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            friendObserver?.dispose()
            friendObserver = viewModel.friend.observe { [weak self] friend in
                self?.titleLabel.text = friend.name
            }
            isExpandedObserver?.dispose()
            isExpandedObserver = viewModel.isExpanded.observeNew { [weak self] value in
                value ? self?.expandCell() : self?.collapseCell()
            }
        }
    }
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
    }

    func toggleCellExpansion() {
        viewModel?.toggle()
    }

    // Hide expanded view with pass times
    func collapseCell(animated animated: Bool = true) {
        if animated {
            tableView?.beginUpdates()
            UIView.animateWithDuration(0.2, animations: { [weak self] () in
                self?.expandArrow.transform = CGAffineTransformMakeRotation(0)
            }) { [weak self] (_) in
                self?.tableView?.endUpdates()
            }
        } else {
            self.expandArrow.transform = CGAffineTransformMakeRotation(0)
        }
    }

    // Call out to open-notify to retrieve pass times, then expand the cell when the data is returned
    func expandCell(animated animated: Bool = true) {
        if animated {
            spinner.startAnimating()
            viewModel?.requestPassTimes { [weak self] (times) in
                self?.spinner.stopAnimating()

                guard let
                    times = times,
                    sself = self
                    else { return }

                self?.tableView?.beginUpdates()
                if self?.expandedView != nil {
                    self?.expandedView?.removeFromSuperview()
                }
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
                self?.tableView?.endUpdates()
            }
        } else {
            guard let expandedView = expandedView else { viewModel?.toggle(); return }
            self.contentView.insertSubview(expandedView, atIndex: 1)
            self.expandedView?.snp_remakeConstraints { (make) -> Void in
                make.left.equalTo(contentView.snp_left)
                make.right.equalTo(contentView.snp_right)
                make.top.equalTo(background.snp_bottom)
                make.bottom.equalTo(contentView.snp_bottom)
            }
            expandArrow.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
        }
    }

    // Deal with reuse issues
    func configure(viewModel: FriendInfoViewModel) {
        self.viewModel = viewModel
        expandArrow.bnd_bag.dispose()
        expandArrow.bnd_tap.observeNew { [weak self] () in
            self?.toggleCellExpansion()
        }
        viewModel.isExpanded.value ? self.expandCell(animated: false) : self.collapseCell(animated: false)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

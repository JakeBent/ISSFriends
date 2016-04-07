//
//  FriendsListViewController.swift
//  ISSFriends
//
//  Created by Jacob Benton on 4/7/16.
//  Copyright © 2016 jakebent. All rights reserved.
//

import UIKit
import SnapKit
import Bond

// This is a controller displayed when tapping on the clock icon on the map. It displays your friend's names and can also show you the next three times the ISS will pass over their location.
class FriendsListViewController: UIViewController {

    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .whiteColor()
        tableView.separatorStyle = .None
        tableView.allowsSelection = false
        tableView.registerCellClass(FriendInfoTableViewCell)
        tableView.alwaysBounceVertical = true
        return tableView
    }()
    let viewModel: FriendsListViewModel!

    init(friends: [Friend]) {
        viewModel = FriendsListViewModel(friends: friends)
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Friends"

        tableView.delegate = self
        view.addSubview(tableView)
        tableView.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(view.snp_edges)
        }

        // Bind view models to table view with reactive framework
        viewModel.viewModels.lift().bindTo(tableView, proxyDataSource: self) { (indexPath, viewModels, tableView) -> UITableViewCell in
            let viewModel = viewModels[indexPath.section][indexPath.row]
            let cell: FriendInfoTableViewCell = tableView.dequeueCellClass(FriendInfoTableViewCell)
            cell.tableView = tableView
            cell.configure(viewModel)
            return cell
        }

        let closeButton = UIButton()
        closeButton.setImage(UIImage(named: "expand_arrow"), forState: .Normal)
        closeButton.sizeToFit()
        closeButton.bnd_tap.observe { [weak self] () in
            self?.dismissViewControllerAnimated(true, completion: nil)
        }
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: closeButton)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FriendsListViewController: UITableViewDelegate, BNDTableViewProxyDataSource {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return viewModel.viewModels[indexPath.row].height()
    }
}
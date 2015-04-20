//
//  ScrollDetailsTableViewController.swift
//  ScrollFun
//
//  Created by Richard Turton on 06/03/2015.
//  Copyright (c) 2015 Richard turton. All rights reserved.
//

import UIKit

struct DelegateMessage {
    let message : String
    let details: String?
    var count : Int
    
    mutating func incrementCount() {
        count++
    }
}

class ScrollDetailsTableViewController: UITableViewController {

    @IBOutlet weak var frameLabel: UILabel!
    @IBOutlet weak var boundsLabel: UILabel!
    @IBOutlet weak var contentSizeLabel: UILabel!
    @IBOutlet weak var contentOffsetLabel: UILabel!
    @IBOutlet weak var insetTopLabel: UILabel!
    @IBOutlet weak var insetRightLabel: UILabel!
    @IBOutlet weak var insetBottomLabel: UILabel!
    @IBOutlet weak var insetLeftLabel: UILabel!
    
    var delegateMessages = [DelegateMessage]()
    
}

extension ScrollDetailsTableViewController : UITableViewDataSource {
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section < 3 {
            return super.tableView(tableView, numberOfRowsInSection: section)
        } else {
            return delegateMessages.count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section < 3 {
            return super.tableView(tableView, cellForRowAtIndexPath:indexPath)
        } else {
            var cell = tableView.dequeueReusableCellWithIdentifier("DelegateCell") as? UITableViewCell
            if cell == nil {
                cell = UITableViewCell(style: .Subtitle, reuseIdentifier: "DelegateCell")
            }
            let delegateMessage = delegateMessages[indexPath.row]
            if delegateMessage.count > 1 {
                cell!.textLabel?.text = "\(delegateMessage.message) x\(delegateMessage.count)"
            } else {
                cell!.textLabel?.text = delegateMessage.message
            }
            cell!.detailTextLabel?.text = delegateMessage.details
            return cell!
        }
    }
}

extension ScrollDetailsTableViewController : UITableViewDelegate {
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section < 3 {
            return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
        } else {
            return 44.0
        }
    }
    
    override func tableView(tableView: UITableView, indentationLevelForRowAtIndexPath indexPath: NSIndexPath) -> Int {
        return 0
    }
}



extension ScrollDetailsTableViewController : ScrollViewListener {
    func updateForScrollview(scrollView : UIScrollView) {
        frameLabel.text = "\(scrollView.frame)"
        boundsLabel.text = "\(scrollView.bounds)"
        contentSizeLabel.text = "\(scrollView.contentSize)"
        contentOffsetLabel.text = "\(scrollView.contentOffset)"
        insetTopLabel.text = "\(scrollView.contentInset.top)"
        insetRightLabel.text = "\(scrollView.contentInset.right)"
        insetBottomLabel.text = "\(scrollView.contentInset.bottom)"
        insetLeftLabel.text = "\(scrollView.contentInset.left)"
    }
    
    func scrollViewDelegateHit(message: String, details:String?) {
        if var lastMessage = delegateMessages.last {
            if lastMessage.message == message {
                lastMessage.incrementCount()
                delegateMessages[delegateMessages.count - 1] = lastMessage
                tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: delegateMessages.count - 1, inSection: 3)], withRowAnimation: .None)
                return
            }
        }
        delegateMessages.append(DelegateMessage(message: message, details:details, count: 1))
        tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: delegateMessages.count - 1, inSection: 3)], withRowAnimation: .None)
    }
    
    func clearMessages() {
        delegateMessages.removeAll(keepCapacity: false)
        tableView.reloadSections(NSIndexSet(index: 3), withRowAnimation: .None)
    }
}

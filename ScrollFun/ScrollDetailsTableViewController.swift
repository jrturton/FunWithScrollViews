//
//  ScrollDetailsTableViewController.swift
//  ScrollFun
//
//  Created by Richard Turton on 06/03/2015.
//  Copyright (c) 2015 Richard turton. All rights reserved.
//

import UIKit

class ScrollDetailsTableViewController: UITableViewController {

    @IBOutlet weak var frameLabel: UILabel!
    @IBOutlet weak var boundsLabel: UILabel!
    @IBOutlet weak var contentSizeLabel: UILabel!
    @IBOutlet weak var contentOffsetLabel: UILabel!
    @IBOutlet weak var insetTopLabel: UILabel!
    @IBOutlet weak var insetRightLabel: UILabel!
    @IBOutlet weak var insetBottomLabel: UILabel!
    @IBOutlet weak var insetLeftLabel: UILabel!
    
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
}

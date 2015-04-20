//
//  ScrollContainerViewController.swift
//  ScrollFun
//
//  Created by Richard Turton on 06/03/2015.
//  Copyright (c) 2015 Richard turton. All rights reserved.
//

import UIKit

@objc protocol ScrollViewListener {
    func updateForScrollview(scrollView : UIScrollView) -> Void
    func scrollViewDelegateHit(message: String, details: String?) -> Void
    func clearMessages() -> Void
}

class ScrollContainerViewController: UIViewController {

    @IBOutlet weak var insetMarker: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var topInset : NSLayoutConstraint!
    @IBOutlet weak var rightInset : NSLayoutConstraint!
    @IBOutlet weak var bottomInset : NSLayoutConstraint!
    @IBOutlet weak var leftInset : NSLayoutConstraint!
    
    @IBOutlet weak var topStepper : UIStepper!
    @IBOutlet weak var rightStepper : UIStepper!
    @IBOutlet weak var bottomStepper : UIStepper!
    @IBOutlet weak var leftStepper : UIStepper!
    
    var scrollViewListener : ScrollViewListener?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        let contentView = UIView(frame: CGRect(x: 0, y: 0, width: 400, height: 400))
        for rowNumber in 0..<10 {
            for columnNumber in 0..<10 {
                let originX = CGFloat(rowNumber) * 40.0
                let originY = CGFloat(columnNumber) * 40.0
                let label = UILabel(frame: CGRect(x: originX, y: originY, width: 40, height: 40))
                label.text = "\(rowNumber) \(columnNumber)"
                label.layer.borderWidth = 1.0
                label.layer.borderColor = UIColor.lightGrayColor().CGColor
                label.textAlignment = .Center
                contentView.addSubview(label)
                
            }
        }
        
        scrollView.addSubview(contentView)
        scrollView.contentSize = contentView.bounds.size
        scrollView.layer.borderWidth = 2
        scrollView.layer.borderColor = UIColor(red: 0, green: 0, blue: 1, alpha: 0.4).CGColor
        
        insetMarker.layer.borderWidth = 2
        insetMarker.layer.borderColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.4).CGColor
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        scrollViewListener?.updateForScrollview(scrollView)
    }
}

extension ScrollContainerViewController {
    
    @IBAction func stepperChanged(sender: UIStepper) {
        let value = CGFloat(sender.value)
        switch sender{
        case topStepper:
            scrollView.contentInset.top = value
        case rightStepper:
            scrollView.contentInset.right = value
        case bottomStepper:
            scrollView.contentInset.bottom = value
        case leftStepper:
            scrollView.contentInset.left = value
        default:
            break
        }
        updateInsetMarker()
        scrollViewListener?.updateForScrollview(scrollView)
    }
    
    func updateInsetMarker() {
        let insets = scrollView.contentInset;
        topInset.constant = insets.top
        rightInset.constant = insets.right
        bottomInset.constant = insets.bottom
        leftInset.constant = insets.left
    }
}

extension ScrollContainerViewController : UIScrollViewDelegate {
  
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        scrollViewListener?.clearMessages()
        scrollViewListener?.scrollViewDelegateHit("scrollViewWillBeginDragging",details:nil)
    }
  
    func scrollViewDidScroll(scrollView: UIScrollView) {
        scrollViewListener?.updateForScrollview(scrollView)
        scrollViewListener?.scrollViewDelegateHit("scrollViewDidScroll",details:nil)
    }
    
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        scrollViewListener?.scrollViewDelegateHit("scrollViewWillEndDragging",details:"velocity \(velocity.rounded()) targetOffset \(targetContentOffset.memory.rounded())")
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        scrollViewListener?.scrollViewDelegateHit("scrollViewDidEndDragging", details:"will decelerate \(decelerate)")
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        scrollViewListener?.scrollViewDelegateHit("scrollViewDidEndDecelerating",details:nil)
    }
}

extension CGPoint {
    func rounded() -> CGPoint {
        return CGPoint(x: round(self.x), y: round(self.y))
    }
}

//
//  CoordinatorLayoutManager.swift
//  
//
//  Created by ChungTV on 18/09/2023.
//

import UIKit

public final class CoordinatorLayoutManager: NSObject, UIScrollViewDelegate {
    
    private weak var coordinatorLayout: CoordinatorLayoutProcotol?
    private var heightConstraint: NSLayoutConstraint?
    
    private var previousScrollOffset: CGFloat = 0.0
    
    public override init() {
        super.init()
    }
    
    public func attach(to layout: CoordinatorLayoutProcotol?) {
        guard let layout = layout else {
            return
        }
        heightConstraint = layout.constraints.first(where: { $0.firstAttribute == .height })
        heightConstraint?.constant = layout.maxHeight
        coordinatorLayout = layout
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let headerHeightConstraint = heightConstraint,
              let coordinatorLayout = coordinatorLayout else {
            return
        }
        let scrollDiff = scrollView.contentOffset.y - previousScrollOffset
        let absoluteTop: CGFloat = 0.0
        let absoluteBottom: CGFloat = scrollView.contentSize.height - scrollView.frame.size.height
        
        let isScrollingDown = scrollDiff > 0 && scrollView.contentOffset.y > absoluteTop
        let isScrollingUp = scrollDiff < 0 && scrollView.contentOffset.y < absoluteBottom
        
        guard canAnimateHeader(scrollView) else {
            return
        }
        
        var newHeight = headerHeightConstraint.constant
        if isScrollingDown {
            newHeight = max(coordinatorLayout.minHeight,
                            headerHeightConstraint.constant - abs(scrollDiff))
        } else if isScrollingUp {
            newHeight = min(coordinatorLayout.maxHeight,
                            headerHeightConstraint.constant + abs(scrollDiff))
        }
        
        if newHeight != headerHeightConstraint.constant {
            headerHeightConstraint.constant = newHeight
            updateLayout()
            setScrollPosition(scrollView, previousScrollOffset)
        }
        
        previousScrollOffset = scrollView.contentOffset.y
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollViewDidStopScrolling()
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            scrollViewDidStopScrolling()
        }
    }
    
    // MARK: Methods
    
    private func canAnimateHeader(_ scrollView: UIScrollView) -> Bool {
        guard let headerHeightConstraint = heightConstraint,
              let coordinatorLayout = coordinatorLayout else {
            return false
        }
        let scrollViewMaxHeight = scrollView.frame.height
            + headerHeightConstraint.constant
            - coordinatorLayout.minHeight
        return scrollView.contentSize.height > scrollViewMaxHeight
    }
    
    private func setScrollPosition(_ scrollView: UIScrollView, _ position: CGFloat) {
        scrollView.contentOffset = CGPoint(x: scrollView.contentOffset.x, y: position)
    }
    
    private func scrollViewDidStopScrolling() {
        guard let heightConstraint = heightConstraint,
              let coordinatorLayout = coordinatorLayout else {
            return
        }
        let range = coordinatorLayout.maxHeight - coordinatorLayout.minHeight
        let midPoint = coordinatorLayout.minHeight + range / 2
        
        if heightConstraint.constant > midPoint {
            expandLayout()
        } else {
            collapseLayout()
        }
    }
    
    private func collapseLayout() {
        guard let heightConstraint = heightConstraint,
              let coordinatorLayout = coordinatorLayout else {
            return
        }
        coordinatorLayout.superview?.layoutIfNeeded()
        UIView.animate(withDuration: 0.2, animations: {
            heightConstraint.constant = coordinatorLayout.minHeight
            self.updateLayout()
            coordinatorLayout.superview?.layoutIfNeeded()
        })
    }
    
    private func expandLayout() {
        guard let heightConstraint = heightConstraint,
              let coordinatorLayout = coordinatorLayout else {
            return
        }
        coordinatorLayout.superview?.layoutIfNeeded()
        UIView.animate(withDuration: 0.2, animations: {
            heightConstraint.constant = coordinatorLayout.maxHeight
            self.updateLayout()
            coordinatorLayout.superview?.layoutIfNeeded()
        })
    }
    
    private func updateLayout() {
        guard let heightConstraint = heightConstraint,
              let coordinatorLayout = coordinatorLayout else {
            return
        }
        let range = coordinatorLayout.maxHeight - coordinatorLayout.minHeight
        let openAmount = heightConstraint.constant - coordinatorLayout.minHeight
        let percentage = openAmount / range
        coordinatorLayout.updateLayout(with: percentage)
    }
}

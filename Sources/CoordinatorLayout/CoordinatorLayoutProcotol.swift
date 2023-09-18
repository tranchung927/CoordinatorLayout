import UIKit

public protocol CoordinatorLayoutProcotol where Self: UIView {
    var maxHeight: CGFloat { get }
    var minHeight: CGFloat { get }
    
    func updateLayout(with percentage: CGFloat)
}

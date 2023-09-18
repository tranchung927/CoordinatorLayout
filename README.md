# CoordinatorLayout

## Usage
```swift
import CoordinatorLayout// import the package

class CustomView: UIView, CoordinatorLayoutProcotol {

    var maxHeight: CGFloat {
        return 120
    }
    
    var minHeight: CGFloat {
        return 40
    }
    
    func updateLayout(with percentage: CGFloat) {
        
    }
}

class ViewController: UIViewController, UIScrollViewDelegate {
    
    private let customView = CustomView()
    private let layoutManager = CoordinatorLayoutManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutManager.attach(to: customView)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        layoutManager.scrollViewDidScroll(scrollView)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        layoutManager.scrollViewDidEndDecelerating(scrollView)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        layoutManager.scrollViewDidEndDragging(scrollView, willDecelerate: decelerate)
    }
}
```

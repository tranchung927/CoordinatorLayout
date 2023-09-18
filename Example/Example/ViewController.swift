//
//  ViewController.swift
//  Example
//
//  Created by ChungTV on 18/09/2023.
//

import UIKit
import CoordinatorLayout

class CustomView: UIView, CoordinatorLayoutProcotol {

    var maxHeight: CGFloat {
        return 120
    }
    
    var minHeight: CGFloat {
        return 40
    }
    
    func updateLayout(with percentage: CGFloat) {
        self.backgroundColor = UIColor.green.withAlphaComponent(percentage)
    }
}

class ViewController: UIViewController, UIScrollViewDelegate {
    private let tableView = UITableView(frame: .zero, style: .plain)
    private let customView = CustomView()
    private let layoutManager = CoordinatorLayoutManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let guide = view.safeAreaLayoutGuide
        
        customView.backgroundColor = .red
        view.addSubview(customView)
        customView.translatesAutoresizingMaskIntoConstraints = false
        customView.heightAnchor.constraint(equalToConstant: customView.maxHeight).isActive = true
        customView.leadingAnchor.constraint(equalTo: guide.leadingAnchor).isActive = true
        customView.trailingAnchor.constraint(equalTo: guide.trailingAnchor).isActive = true
        customView.topAnchor.constraint(equalTo: guide.topAnchor).isActive = true
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: customView.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: guide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: guide.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: guide.bottomAnchor).isActive = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        
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

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
      
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = .yellow
        } else {
            cell.backgroundColor = .orange
        }
        return cell
    }
}

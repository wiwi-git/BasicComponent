//
//  MainViewController.swift
//  BasicComponent
//
//  Created by Emoticbox on 2021/08/27.
//

import UIKit

class MainViewControlelr: UIViewController {
    var tableview: UITableView!
    
    var searchController = UISearchController()
    
    var components: [ComponentItem] = []
    var filteredItems: [ComponentItem] = []
    
    var isSearcing: Bool {
        get{
            !(searchController.searchBar.text?.isEmpty ?? true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in 0...9 {
            let item = ComponentItem(viewName: "index: \(i) | test data")
            self.components.append(item)
        }
        
        tableview = UITableView(frame: CGRect(origin: .zero, size: .zero))
        tableview.backgroundColor = .white
        tableview.delegate = self
        tableview.dataSource = self
        tableview.register(MainTableViewCell.self, forCellReuseIdentifier: MainTableViewCell.reuseId)
        
        self.view.addSubview(tableview!)
        
        tableview.translatesAutoresizingMaskIntoConstraints = false
        let safe = self.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            tableview.topAnchor.constraint(equalTo: safe.topAnchor),
            tableview.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            tableview.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            tableview.bottomAnchor.constraint(equalTo: safe.bottomAnchor)
        ])
        
        searchController = UISearchController(searchResultsController: nil)
        tableview?.tableHeaderView = searchController.searchBar
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.delegate = self
    }
    
}
extension MainViewControlelr: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return isSearcing ? filteredItems.count : components.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.reuseId, for: indexPath) as! MainTableViewCell
        let item = isSearcing ? filteredItems[indexPath.row] : components[indexPath.row]
        cell.titleLabel.text = item.viewName
        return cell
    }
}
extension MainViewControlelr: UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        self.filteredItems = components.filter { innerItem in
            innerItem.viewName.lowercased().contains(searchController.searchBar.text!.lowercased())
        }
        tableview.reloadData()
    }
    
}

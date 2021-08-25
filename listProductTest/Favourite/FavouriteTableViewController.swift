//
//  FavouriteTableViewController.swift
//  listProductTest
//
//  Created by Кирилл Харьковский on 23.08.2021.
//

import UIKit

class FavouriteTableViewController: UIViewController {
    //MARK: - Properties
    private let productAdapter = ProductAdapter()
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.setHeight(UIScreen.main.bounds.height)
        tableView.setHeight(UIScreen.main.bounds.width)
        return tableView
    }()
    
    private let calculateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.text = "Общая стоимость:"
        return label
    }()
    private let summLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .red
        return label
    }()
    
    private var product: [Product]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationController()
        setTableView()
        viewConfigure()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getData()
    }
    
    //MARK: - Helpers
    private func getData() {
        productAdapter.getFavsProductList { productList in
            self.product = productList
            var count = 0.0
            productList.forEach{ count += $0.price}
            self.summLabel.text = "\(count)"
        }
    }
    
    private func setNavigationController(){
        title = "Избранные"
    }
    
    private func setTableView(){
        tableView.showsVerticalScrollIndicator = false
        view.backgroundColor = .white
        self.tableView.register(MainTableViewCell.self, forCellReuseIdentifier: MainTableViewCell.favsProductListCellReuseIdentifier)
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func viewConfigure(){
        let hStack = UIStackView(arrangedSubviews: [calculateLabel, summLabel])
        hStack.axis = .horizontal
        hStack.spacing = 10
        
        view.addSubview(hStack)
        hStack.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddingTop: 10, paddingLeft: 10, height: 30)
        
        view.addSubview(tableView)
        tableView.anchor(top: hStack.bottomAnchor , left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 10, paddingRight: 10)
    }
}
// MARK: - Table view data source
extension FavouriteTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return product == nil ? 0 : product!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard  let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.favsProductListCellReuseIdentifier, for: indexPath) as? MainTableViewCell else { return UITableViewCell() }
        cell.accessoryType = .disclosureIndicator
        cell.delegate = self
        cell.clearCell()
        let product = product?[indexPath.row]
        
        
        cell.likeButton.tintColor = .red
        
        
        
        if product != nil {
            let url = URL(string: product!.imageUrl)
            let productListViewModel = ProductListViewModel(product!)
            cell.configureUIWithProsuctListViewModel(productListVM: productListViewModel)
            DispatchQueue.main.async(execute: {
                cell.proguctPicture.downloadWithSD(from: url)
            });
        }
        
        return cell
    }
    
}

extension FavouriteTableViewController: TapLikeDelegation {
    func tapLike(id: String) {
        productAdapter.tapLike(id)
        getData()
    }
}

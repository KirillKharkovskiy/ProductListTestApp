//
//  MainTableViewController.swift
//  listProductTest
//
//  Created by Кирилл Харьковский on 23.08.2021.
//

import UIKit
import RealmSwift
class MainTableViewController: UITableViewController {
    
    //MARK: - Properties
    private let productAdapter = ProductAdapter()
    private var stateFilters = false
    
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
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getData()
    }
    
    //MARK: - Helpers
    
    private func setTableView(){
        self.tableView.register(MainTableViewCell.self, forCellReuseIdentifier: MainTableViewCell.productListCellReuseIdentifier)
        tableView.showsVerticalScrollIndicator = false
    }
    private func setNavigationController(){
        title = "Главная"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.up.arrow.down.square"), style: .plain, target: self, action: #selector(filterProductList))
    }
    
    //MARK: - Action
    @objc func filterProductList(){
        if stateFilters {
            // сортировка по рейтингу
            product = product?.sorted{$0.weight < $1.weight}
            stateFilters.toggle()
        } else {
            // сортировка по цене
            product = product?.sorted{$0.price < $1.price}
            stateFilters.toggle()
        }
    }
    
    //MARK: - Get data
    private func getData(){
        product?.removeAll()
        productAdapter.getProductList{ product in
            self.product = product
        }
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return product == nil ? 0 : product!.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard  let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.productListCellReuseIdentifier, for: indexPath) as? MainTableViewCell else { return UITableViewCell() }
        cell.accessoryType = .disclosureIndicator
        cell.delegate = self
        cell.clearCell()
        let product = product?[indexPath.row]
        if product?.isSelected == true {
            cell.likeButton.tintColor = .red
        } else {
            cell.likeButton.tintColor = .black
        }
        
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
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

//MARK: - TapLikeDelegation
extension MainTableViewController: TapLikeDelegation {
    func tapLike(id: String) {
        productAdapter.tapLike(id)
        getData()
        guard let realm = try? Realm() else { return }
        let productRealm = realm.objects(ProductListRealmModel.self)
        
        print(productRealm)
    }
}

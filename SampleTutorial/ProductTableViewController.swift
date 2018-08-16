//
//  ProductTableViewController.swift
//  SampleTutorial
//
//  Created by Boris Angelov on 1/30/17.
//  Copyright © 2017 Boris Angelov. All rights reserved.
//

import UIKit

class ProductTableViewController: UITableViewController {
    
    public var category: Category!
    public var products = [Product]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleProductsLoaded), name: .onProductsLoaded, object: nil)
        RestaurantService.loadProducts(categoryId: self.category.id)
        
        self.navigationItem.title = self.category.name
    }
    
    @objc private func handleProductsLoaded(notification: Notification) {
        self.products = notification.object as! [Product]
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.products.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "productCell", for: indexPath) as! ProductTableViewCell
        
        // Configure the cell...
        let product = self.products[indexPath.row]
        cell.bgImageView.getImgFromUrl(link: product.image, contentMode: .scaleAspectFill)
        cell.nameLabel.text = product.name
        cell.priceLabel.text = product.price.description
        cell.descriptionLabel.text = product.description
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let productController = segue.destination as! ProductViewController
        
        if let selectedProductCell = sender as? ProductTableViewCell {
            let indexPath = self.tableView.indexPath(for: selectedProductCell)!
            let product = self.products[indexPath.row]
            productController.product = product
        }
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animateTable()
    }
    func animateTable() {
        tableView.reloadData()
        let cells = tableView.visibleCells
        let tableViewHeight = tableView.bounds.size.height
        
        for cell in cells {
            cell.transform = CGAffineTransform(translationX: 0, y: tableViewHeight)
        }
        
        var delayCounter = 0
        for cell in cells {
            UIView.animate(withDuration: 1.75, delay: Double(delayCounter) * 0.05, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                cell.transform = CGAffineTransform.identity
            }, completion: nil)
            delayCounter += 1
        }
        
    }
    override public var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    override public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        // 1. set the initial state of the cell
        cell.alpha = 0
        let transform = CATransform3DTranslate(CATransform3DIdentity, -250, 20, 0)
        cell.layer.transform = transform
        
        // 2. UIView animation method to change to the final state of the cell
        UIView.animate(withDuration: 1.0, animations: {
            cell.alpha = 1.0
            cell.layer.transform = CATransform3DIdentity
        })
    }
    
}

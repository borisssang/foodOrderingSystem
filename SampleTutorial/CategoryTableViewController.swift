//
//  CategoryTableViewController.swift
//  SampleTutorial
//
//  Created by Boris Angelov on 1/30/17.
//  Copyright © 2017 Boris Angelov. All rights reserved.
//
import UIKit

class CategoryTableViewController: UITableViewController{
    
    public var restaurant: Restaurant!
    public var categories = [Category]()
    public var contents: (restaurantId: Int, tableId: Int)!
    var editedPhoneNumber = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        RestaurantService.setupForCategories(restaurantId: self.contents!.restaurantId, tableId: self.contents!.tableId)
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleCategoriesLoaded), name: .onCategoriesLoaded, object: nil)
        RestaurantService.loadCategories()
        self.navigationItem.title = restaurant.name
    }
    
    @objc private func handleCategoriesLoaded(notification: Notification) {
        self.categories = notification.object as! [Category]
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as! CategoryTableViewCell
        
        // Configure the cell...
        cell.nameLabel.text = self.categories[indexPath.row].name
        cell.bgImageView.getImgFromUrl(link: categories[indexPath.row].image, contentMode: .scaleAspectFill)
        
        return cell
    }
    
    override public func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let productController = segue.destination as? ProductTableViewController {
            if let selectedCategoryCell = sender as? CategoryTableViewCell {
                let indexPath = tableView.indexPath(for: selectedCategoryCell)!
                let category = self.categories[indexPath.row]
                productController.category = category
            }
        }
    }
    @IBAction func callNumber(_ sender: UIBarButtonItem) {
        call(phoneNumber: restaurant.phoneNumber)
    }
    
    func call(phoneNumber: String){
        if phoneNumber != "" {
            guard let number = URL(string: "telprompt://" + phoneNumber) else { return }
            UIApplication.shared.open(number, options: [:], completionHandler: nil)
        } else {
            let alertController = YBAlertController(title: "Упс", message: "Номерът е невалиден", style: .actionSheet)
            alertController.touchingOutsideDismiss = true
            alertController.show()
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

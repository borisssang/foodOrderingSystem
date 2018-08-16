//
//  RestaurantsTableViewController.swift
//  SampleTutorial
//
//  Created by Boris Angelov on 1/20/17.
//  Copyright © 2017 Boris Angelov. All rights reserved.
//

import UIKit
import SafariServices

public class RestaurantsTableViewController: UITableViewController, UISearchBarDelegate{
    
    public var filteredArr = [Restaurant]()
    public var keywords: String!
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        self.tableView.backgroundColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
        RestaurantService.setupForRestaurants(keywords: keywords)
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleRestaurantsLoaded), name: .onRestaurantsLoaded, object: nil)
        RestaurantService.loadRestaurants()
    }
    
    @objc private func handleRestaurantsLoaded(notification: Notification) {
        self.filteredArr = notification.object as! [Restaurant]
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    override public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredArr.count
    }
    
    override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "restaurantCell", for: indexPath) as! RestaurantTableViewCell
        let model = filteredArr[indexPath.row]
        
        cell.restaurantLabel.text = model.name
        cell.restaurantImage.getImgFromUrl(link: model.image, contentMode: .scaleAspectFill)
        cell.restaurantAddress.text = model.address
        cell.restaurantDescribtion.text = model.description
        
        return cell
    }
    
    override public func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let categoryController = segue.destination as? CategoryTableViewController {
            if let selectedRestaurantCell = sender as? RestaurantTableViewCell {
                let indexPath = tableView.indexPath(for: selectedRestaurantCell)!
                let restaurant = self.filteredArr[indexPath.row]
                categoryController.contents = (restaurant.id,1)
                categoryController.restaurant = restaurant
            }
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
    
    @IBAction func fullBlogDidTap(_ sender: AnyObject)
    {
        let alertController = YBAlertController(title: "Привет!", message: "Посетете ни и оставете съобщение или споделете с приятели:", style: .actionSheet)
        
        alertController.addButton(UIImage(named: "comment"), title: "Посете нашият сайт") {
            // import SafariServices
            let safariVC = SFSafariViewController(url: URL(string: "http://www.codingfellas.com")!)
            safariVC.view.tintColor = UIColor(red: 248/255.0, green: 47/255.0, blue: 38/255.0, alpha: 1.0)
            safariVC.delegate = self
            self.present(safariVC, animated: true, completion: nil)
            alertController.buttonIconColor = UIColor(red: 248/255.0, green: 47/255.0, blue: 38/255.0, alpha: 1.0)
        }
        
        alertController.addButton(UIImage(named: "tweet"), title: "Харесайте ни във Facebook") {
            let safariVC = SFSafariViewController(url: URL(string: "http://www.facebook.com")!)
            safariVC.view.tintColor = UIColor(red: 248/255.0, green: 47/255.0, blue: 38/255.0, alpha: 1.0)
            safariVC.delegate = self
            self.present(safariVC, animated: true, completion: nil)
        }
        
        alertController.touchingOutsideDismiss = true
        alertController.show()
    }
}

extension RestaurantsTableViewController : SFSafariViewControllerDelegate
{
    public func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}

//
//  PopUpVCViewController.swift
//  SampleTutorial
//
//  Created by Boris Angelov on 1/29/17.
//  Copyright © 2017 Boris Angelov. All rights reserved.
//

import UIKit

public class PopUpVCViewController: UIViewController, UISearchBarDelegate{
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
    }
    
    //makes the searchBar pretty
    func setupSearchBar(){
        searchBar.showsScopeBar = true
        searchBar.scopeButtonTitles = ["Име","Тип храна"]
        searchBar.selectedScopeButtonIndex = 0
        searchBar.layer.cornerRadius = 3.0
        searchBar.clipsToBounds = true
        
        //removing keybord when user taps the screen
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(PopUpVCViewController.dismissKeyboard))
        //enables other options
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    //Calls this function when the tap is recognized.
    public func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    //dismisses keybord when search key is pressed
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        dismissKeyboard()
    }
    
    @IBAction func showResults(_ sender: Any) {
      //  filterTableView(ind: searchBar.selectedScopeButtonIndex, text: searchBar.text!)
        performSegue(withIdentifier: "showResults", sender: nil)
    }
    
    override public func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showResults"{
            let destinationVC = segue.destination as? UINavigationController
            let targetController: RestaurantsTableViewController = destinationVC?.topViewController as! RestaurantsTableViewController
            targetController.keywords = searchBar.text!
        }
    }
    @IBAction func dismissPopUp(_ sender: UIButton) {
        dismiss(animated:  true, completion: nil)
    }
}

//
//  animationVCViewController.swift
//  SampleTutorial
//
//  Created by Boris Angelov on 1/28/17.
//  Copyright © 2017 Boris Angelov. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {
    
    @IBOutlet weak var constraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        constraint.constant -= view.bounds.width
    }
    
    var animationPerformedOnce = false
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !animationPerformedOnce {
            
            UIView.animate(withDuration: 0.5, delay: 0.2, options: .curveEaseOut, animations: {
                self.constraint.constant += self.view.bounds.width
                self.view.layoutIfNeeded()
            }, completion: nil)
            
            animationPerformedOnce = true
        }
        
    }
}

//
//  ProductViewController.swift
//  SampleTutorial
//
//  Created by Boris Angelov on 1/30/17.
//  Copyright © 2017 Boris Angelov. All rights reserved.
//

import UIKit

class ProductViewController: UIViewController {
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var bgImageView: UIImageView!
    
    public var product: Product!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleIngredientsLoaded), name: .onIngredientsLoaded, object: nil)
        RestaurantService.loadProductIngredients(productId: product.id)
        
        self.navigationItem.title = product.name
        self.descriptionLabel.text = self.product.description
        self.priceLabel.text = self.product.price.description
        bgImageView.getImgFromUrl(link: self.product.image, contentMode: .scaleAspectFill)
    }
    
    //    @IBAction func addToOrder(_ sender: Any) {
    //        Order.orderList.append(self.product)
    //    }
    
    @objc private func handleIngredientsLoaded(notification: Notification) {
        self.product.ingredients = (notification.object as! [Ingredient])
        
        DispatchQueue.main.async {
            let ingredientsLabel = self.view.viewWithTag(1)! as! UILabel
            var lastY = ingredientsLabel.center.y
            
            for i in 0..<self.product.ingredients!.count {
                let ingredient = self.product.ingredients![i]
                
                let label = IngredientLabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
                label.index = i
                
                label.text = ingredient.name
                label.sizeToFit()
                label.backgroundColor = ingredient.included ? .green : .red
                label.isUserInteractionEnabled = true
                
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleIngredientToggle))
                label.addGestureRecognizer(tapGesture)
                
                let newY = lastY + 30
                lastY = newY
                
                label.center = CGPoint(x: label.frame.size.width / 2 + 16, y: newY)
                
                self.view.viewWithTag(2)!.addSubview(label)
            }
        }
    }
    
    @objc private func handleIngredientToggle(sender: UITapGestureRecognizer) {
        let label = sender.view as! IngredientLabel
        let ingredient = self.product.ingredients![label.index]
        ingredient.included = !ingredient.included
        label.backgroundColor = ingredient.included ? .green : .red
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

//
//  RestaurantService.swift
//  SampleTutorial
//
//  Created by Boris Angelov on 1/30/17.
//  Copyright © 2017 Boris Angelov. All rights reserved.
//

import Foundation
import UIKit

public class RestaurantService {
    private static let baseUrl = "http://ater.azurewebsites.net"
    
    private static let defaultSession = URLSession(configuration: .default)
    private static var dataTask: URLSessionDataTask?
    
    private static var restaurantId: Int!
    private static var tableId: Int!
    private static var keywords: String!
    
    public static func setupForCategories(restaurantId: Int, tableId: Int) {
        self.restaurantId = restaurantId
        self.tableId = tableId
    }
    public static func setupForRestaurants(keywords: String){
        self.keywords = keywords
    }
    
    private static func getRequest(urlPath: String, completionHandler: @escaping (_: Data?) -> Void) {
        if dataTask != nil {
            dataTask?.cancel()
        }
        
        // Indicate that the app is loading
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let url = URL(string: urlPath)!
        
        dataTask = defaultSession.dataTask(with: url, completionHandler: {
            data, response, error in
            
            // Indicate that the app is done loading
            DispatchQueue.main.async {
                print("done")
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
            
            if let error = error {
                print(error.localizedDescription)
            } else if let res = response as? HTTPURLResponse {
                print("res", res.statusCode)
                // If everything is fine, handle the data
                if res.statusCode == 200 {
                    completionHandler(data)
                }
            }
        })
        
        dataTask?.resume()
    }
    
    public static func loadRestaurants(){
        //      let urlPath = "\(baseUrl)/api/restaurants/search?q=\(keywords)"
        let sampleUrlPathForJson = "http://pastebin.com/raw/mQcDFkDa"
        //      print(urlPath)
        getRequest(urlPath: sampleUrlPathForJson, completionHandler: {
            data in
            
            let json = try! JSONSerialization.jsonObject(with: data!, options: []) as! [Any]
            
            var restaurants = [Restaurant]()
            for jsonCategory in json {
                let jsonDict = jsonCategory as! Dictionary<String, Any>
                
                let id = (jsonDict["id"] as! NSString).integerValue
                let name = jsonDict["name"] as! String
                let image = jsonDict["image"] as! String
                let address = jsonDict["address"] as! String
                let typeOfFood = jsonDict["typeOfFood"] as! String
                let description = jsonDict["description"] as! String
                let phoneNumber = jsonDict["phoneNumber"] as! String
                let restaurant = Restaurant(id: id, name: name,phoneNumber: phoneNumber, address: address, image: image, typeOfFood: typeOfFood, description: description)
                restaurants.append(restaurant)
            }
            NotificationCenter.default.post(name: .onRestaurantsLoaded, object: restaurants)
        })
    }
    
    public static func loadCategories() {
        //  let urlPath = "\(baseUrl)/api/restaurants/\(restaurantId!)/categories"
        let SampleUrlPath = "http://pastebin.com/raw/nKetWiFa"
        //  print(urlPath)
        getRequest(urlPath: SampleUrlPath, completionHandler: {
            data in
            
            let json = try! JSONSerialization.jsonObject(with: data!, options: []) as! [Any]
            
            var categories = [Category]()
            for jsonCategory in json {
                let jsonDict = jsonCategory as! Dictionary<String, Any>
                
                let id = (jsonDict["id"] as! NSString).integerValue
                let name = jsonDict["name"] as! String
                let image = jsonDict["image"] as! String
                
                let category = Category(id: id, name: name, image: image)
                categories.append(category)
            }
            
            NotificationCenter.default.post(name: .onCategoriesLoaded, object: categories)
        })
    }
    
    public static func loadProducts(categoryId: Int) {
        //  let urlPath = "\(baseUrl)/api/categories/\(categoryId)/products"
        let samplePaste = "http://pastebin.com/raw/3NjKK00b"
        getRequest(urlPath: samplePaste, completionHandler: {
            data in
            
            let json = try! JSONSerialization.jsonObject(with: data!, options: []) as! [Any]
            
            var products = [Product]()
            for jsonProduct in json {
                let jsonDict = jsonProduct as! Dictionary<String, Any>
                
                let id = (jsonDict["id"] as! NSString).integerValue
                let name = jsonDict["name"] as! String
                let image = jsonDict["image"] as! String
                let description = jsonDict["description"] as! String
                let price = (jsonDict["price"] as! NSString).integerValue
                let weight = (jsonDict["weight"] as! NSString).integerValue
                //  let timesOrdered = jsonDict["timesOrdered"] as! Int
                
                let product = Product(id: id, name: name, description: description, image: image, price: Decimal(price), weight: weight)
                products.append(product)
            }
            NotificationCenter.default.post(name: .onProductsLoaded, object: products)
        })
    }
    
    public static func loadProductIngredients(productId: Int) {
        let urlPath = "\(baseUrl)/api/products/\(productId)/ingredients"
        getRequest(urlPath: urlPath, completionHandler: {
            data in
            
            let json = try! JSONSerialization.jsonObject(with: data!, options: []) as! [Any]
            
            var ingredients = [Ingredient]()
            for jsonIngredient in json {
                let jsonDict = jsonIngredient as! Dictionary<String, Any>
                
                let id = jsonDict["Id"] as! Int
                let name = jsonDict["Name"] as! String
                let isAllergen = jsonDict["IsAllergen"] as! Bool
                
                let ingredient = Ingredient(id: id, name: name, isAllergen: isAllergen)
                ingredients.append(ingredient)
            }
            NotificationCenter.default.post(name: .onIngredientsLoaded, object: ingredients)
        })
    }
    
    //    public static func placeOrder() {
    //        var products = [OrderViewModel]()
    //        for order in Order.orderList {
    //            products.append(OrderViewModel(productId: order.id))
    //        }
    //        ///////////////////////////// какъв е тоя обект
    //        let jsonObject = ["DeviceUUID": "ya", "Comment": "comment", "OrderedProducts": products.description] as [String : Any]
    //        let json = try! JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
    //
    //        // create post request
    //        let url = URL(string: "api/tables/\(tableId)/createorder")!
    //        var request = URLRequest(url: url)
    //        request.httpMethod = "POST"
    //
    //        // insert json data to the request
    //        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
    //        request.httpBody = json
    //
    //        dataTask = defaultSession.dataTask(with: request, completionHandler: {
    //            data, response, error in
    //
    //            // Indicate that the app is done loading
    //            DispatchQueue.main.async {
    //                print("done")
    //                UIApplication.shared.isNetworkActivityIndicatorVisible = false
    //            }
    //
    //            if let error = error {
    //                print(error.localizedDescription)
    //            } else if let res = response as? HTTPURLResponse {
    //                print("res", res.statusCode)
    //                // If everything is fine, handle the data
    //                if res.statusCode == 200 {
    //                    
    //                }
    //            }
    //        })
    //        
    //        dataTask?.resume()
    //    }
}

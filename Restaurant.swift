//
//  Restaurant.swift
//  SampleTutorial
//
//  Created by Boris Angelov on 1/20/17.
//  Copyright © 2017 Boris Angelov. All rights reserved.
//

import Foundation

public class Restaurant {
    public var id: Int!
    public var name: String!
    public var address: String!
    public var phoneNumber: String!
    // public var capacity: Int!
    public var image: String!
    public var typeOfFood: String!
    public var description: String!
    
    init(id: Int, name: String, phoneNumber: String, address: String, image: String!, typeOfFood: String, description: String) {
        self.id = id
        self.name = name
        self.phoneNumber = phoneNumber
        //     self.capacity = capacity
        self.address = address
        self.image = image
        self.typeOfFood=typeOfFood
        self.description = description
    }
}

//
//  Ingridient.swift
//  SampleTutorial
//
//  Created by Boris Angelov on 1/30/17.
//  Copyright © 2017 Boris Angelov. All rights reserved.
//

import Foundation

public class Ingredient {
    public var id: Int!
    public var name: String!
    public var isAllergen: Bool!
    public var included = true
    
    init(id: Int, name: String, isAllergen: Bool) {
        self.id = id
        self.name = name
        self.isAllergen = isAllergen
    }
}

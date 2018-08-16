//
//  DesignablePopUp.swift
//  SampleTutorial
//
//  Created by Boris Angelov on 1/29/17.
//  Copyright © 2017 Boris Angelov. All rights reserved.
//

import UIKit

@IBDesignable class DesignablePopUp: UIView {
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet{
            self.layer.cornerRadius = cornerRadius
        }
    }
    
}

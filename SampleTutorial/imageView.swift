//
//  imageView.swift
//  SampleTutorial
//
//  Created by Boris Angelov on 1/30/17.
//  Copyright © 2017 Boris Angelov. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    func getImgFromUrl(link:String, contentMode mode: UIViewContentMode) {
        guard
            let url = NSURL(string: link)
            else {return}
        contentMode = mode
        URLSession.shared.dataTask(with: url as URL, completionHandler: { (data, response, error) -> Void in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async{ () -> Void in
                print("set")
                self.image = image
            }
        }).resume()
    }
}

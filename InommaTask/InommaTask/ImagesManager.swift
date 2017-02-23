//
//  ImagesManager.swift
//  InommaTask
//
//  Created by Codefights on 2/22/17.
//  Copyright © 2017 Codefights. All rights reserved.
//

import UIKit

struct ImagesManager {
    
    func downloadImages(_ imageUrl: String, completionHandler: @escaping (UIImage) -> Void ) {
        let imageURL = URL(string: imageUrl)
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: imageURL!)
            DispatchQueue.main.async {
                completionHandler(UIImage(data: data!)!)
            }
        }
    }
}

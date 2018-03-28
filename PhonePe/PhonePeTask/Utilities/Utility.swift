//
//  Utill.swift
//  QuickrTask
//
//  Created by Hos on 25/01/18.
//  Copyright © 2018 HoshiyarSinghQuikrTask. All rights reserved.
//

import Foundation
import  UIKit

final class Utility
{
    
   static func showAlertWith(title: String, message: String, style: UIAlertControllerStyle = .alert,controller:UIViewController) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        let action = UIAlertAction(title: title, style: .default) { (action) in
            controller.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(action)
        controller.present(alertController, animated: true, completion: nil)
    }
    
}


let imageCache = NSCache<NSString, UIImage>()


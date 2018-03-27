//
//  ImageCollectionViewCell.swift
//  PhonePayTask
//
//  Created by Hos on 27/03/18.
//  Copyright © 2018 hos.lbox.PhonePayTask. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell
{
    var myFlickr:Flickr?
    {
        didSet
        {
            updateImage()
        }
    }
    
    func updateImage()
    {
        imageView.downloadImageUsingCacheWithURLString(myFlickr!.getMyUrl(), placeHolder:UIImage(named: "placeholder") )
    }
    @IBOutlet weak var imageView: MyCacheableImageView!
    
}

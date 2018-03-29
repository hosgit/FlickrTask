//
//  Constants.swift
//  phonepeTask
//
//  Created by Hos on 27/03/18.
//  Copyright © 2018 hos.lbox.phonepeTask. All rights reserved.
//

import Foundation

struct LocalURL
{
    public static func  getFlickrUrlFrom(page:Int,text:String) -> String
    {
        let imageURL = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=f2ddfcba0e5f88c2568d96dcccd09602&format=json&nojsoncallback=1&safe_search=1&page=\(page)&text=\(text)"
        return imageURL
    }
}

struct NetworkConstants
{
    static let httpGet = "GET"
    static let headerAcceptTypeJSON = "application/json"
    static let responsePhotosKey = "photos"
    static let responsePhotoArrayKey = "photo"
}


struct  CellIds
{
    static let flickerImageCellId = "imageCell"
    static let serahcHistoyCellId = "history"
}

struct FlikrModelKeys
{
    static let id    = "id"
    static let owner  = "owner"
    static let server  = "server"
    static let farm   = "farm"
    static let title  = "title"
    static let secret = "secret"
}

struct InterSapce
{
    static let landscapeSpacing:Double = ((15.0 * 3.0)-20.0) / 2.0 // ((remaingSpace * number of cells ) - inscts) / number of gaps in columns
    static let portraitSpacing:Double = (15.0 * 2.0) - 20.0
}

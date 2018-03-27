//
//  Constants.swift
//  PhonePayTask
//
//  Created by Hos on 27/03/18.
//  Copyright © 2018 hos.lbox.PhonePayTask. All rights reserved.
//

import Foundation
struct StoryBoardID
{
    static let detailController = "RestaurantDetailViewController"
}

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
    static let headerAcceptKey = "Accept"
    static let headerUserKey = "user-key"
    static let headerAcceptTypeJSON = "application/json"
    static let headerUserValue = "141fd96cb14d6cb1ef428e50b5aed26a"
    static let responsePhotosKey = "photos"
    static let responsePhotoArrayKey = "photo"

}

struct  cellIds
{
    static let restaurantCellId = "cellID"
}

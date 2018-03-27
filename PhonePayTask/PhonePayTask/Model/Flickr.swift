//
//  Flickr.swift
//  PhonePayTask
//
//  Created by Hos on 27/03/18.
//  Copyright © 2018 hos.lbox.PhonePayTask. All rights reserved.
//

import Foundation

struct Flickr
{
    var id:String
    var owner:String
    var server:String
    var farm:Int
    var title:String
    var secret:String
    init(dataDict:Dictionary<String,AnyObject>)
    {
            self.id    = dataDict["id"] as? String ?? "no id"
            self.owner  = dataDict["owner"] as? String ?? "no woner"
            self.server  = dataDict["server"] as? String ?? "no server"
            self.farm   = dataDict["farm"] as? Int ?? 0
            self.title  = dataDict["title"] as? String ?? "no title"
            self.secret = dataDict["secret"] as? String ?? "no secret"
    }
    func getMyUrl()->String
    {
       return "https://farm\(farm).static.flickr.com/\(server)/\(id)_\(secret).jpg"
    }
}

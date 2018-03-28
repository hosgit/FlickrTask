//
//  Flickr.swift
//  phonepeTask
//
//  Created by Hos on 27/03/18.
//  Copyright © 2018 hos.lbox.phonepeTask. All rights reserved.
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
            self.id    = dataDict[FlikrModelKeys.id] as? String ?? "no id"
            self.owner  = dataDict[FlikrModelKeys.owner] as? String ?? "no owner"
            self.server  = dataDict[FlikrModelKeys.server] as? String ?? "no server"
            self.farm   = dataDict[FlikrModelKeys.farm] as? Int ?? 0
            self.title  = dataDict[FlikrModelKeys.title] as? String ?? "no title"
            self.secret = dataDict[FlikrModelKeys.secret] as? String ?? "no secret"
    }
    func getMyUrl()->String
    {
       return "https://farm\(farm).static.flickr.com/\(server)/\(id)_\(secret).jpg"
    }
}

//
//  NetworkManager.swift
//  PhonePayTask
//
//  Created by Hos on 27/03/18.
//  Copyright © 2018 hos.lbox.PhonePayTask. All rights reserved.
//

//https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=f2ddfcba0e5f88c2568d96dcccd0960 2&format=json&nojsoncallback=1&safe_search=1&text=kittens
import Foundation
final public class NetworkManger
{
    static func getRestaurantsNearMe(page:Int, text value:String,completion: @escaping (Result<[[String: AnyObject]]>) -> Void)
    {
        let urlString = LocalURL.getFlickrUrlFrom(page: page, text: value)
        let url:URL = URL(string:urlString)!
        var request = URLRequest(url: url)
        request.setValue(NetworkConstants.headerAcceptTypeJSON, forHTTPHeaderField: NetworkConstants.headerAcceptKey)
        request.setValue(NetworkConstants.headerUserValue, forHTTPHeaderField: NetworkConstants.headerUserKey)
        request.httpMethod = NetworkConstants.httpGet
        
        _ = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard error == nil else {  return completion(.Error(error!.localizedDescription))  }
            guard let unwrappedData = data else {return completion(.Error(error?.localizedDescription ?? "No Images to show")) }
            do {
                guard let result = try JSONSerialization.jsonObject(with: unwrappedData, options: .allowFragments) as? Dictionary<String,AnyObject>
                    else{return completion(.Error(error?.localizedDescription ?? "No Images to show")) }
                if let photoData = result[NetworkConstants.responsePhotosKey] as? Dictionary<String,AnyObject>
                {
                    if let photosList = photoData[NetworkConstants.responsePhotoArrayKey] as? Array<Dictionary<String,AnyObject>>
                    {
                        print(photosList.count)
                        DispatchQueue.main.async {
                            completion(.Success(photosList))
                        }
                    }
                }
            } catch let error {
                completion(.Error(error.localizedDescription))
            }
            }.resume()
    }
}

enum Result<T> {
    case Success(T)
    case Error(String)
}

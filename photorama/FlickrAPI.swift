//
//  FlickrAPI.swift
//  photorama
//
//  Created by Peter Gorgone on 3/19/18.
//  Copyright © 2018 Peter S Gorgone. All rights reserved.
//

import Foundation

// enum for Flickr endpoints
enum Method: String {
    case interestingPhotos = "flickr.interestingness.getList"
}

// Responsible for knwoing and handling all Flickr-related information, including...
//  ~ knowing how to generate URLS that Flickr API expects
//  ~ knowing format of incoming JSON and how to prse JSON into relevan model objects
struct FlickrAPI {
    
    // type-level property referencing base URL
    private static let baseUrlString = "https://api.flickr.com/services/rest"
    private static let apiKey = "f4ec178aa2d1ecdc7e33f80554b9f027"
    
    // method type that builds up URL for a specific endpoint
    //   ~ construct an isntance of URLComponents from the base URL, then
    //     loop over incoming params and crate the associated URLQueryItem instances
    // 1st arg: which endpoint to hit via Method enum
    // 2nd arg: optional dictionary of query item params
    // private b/c this is an implemenation detail
    private static func flickrURL(method: Method, parameters: [String:String]?) -> URL {
        var components = URLComponents(string: baseUrlString)!
        
        var queryItems = [URLQueryItem]()
        
        // Common query items
        let baseParams = [
            "method": method.rawValue,
            "format": "json",
            "nojsoncallback": "1",
            "api_key": apiKey
        ]
        for (key, value) in baseParams {
            let item = URLQueryItem(name: key, value: value)
            queryItems.append(item)
        }
        
        if let additionalParams = parameters {
            for (key, value) in additionalParams {
                let item = URLQueryItem(name: key, value: value)
                queryItems.append(item)
            }
        }
        components.queryItems = queryItems
        return components.url!
    }
    
    
    // computed property
    static var interestingPhotosURL: URL {
        return flickrURL(method: .interestingPhotos, parameters: ["extras": "url_h,date_taken"])
    }
}

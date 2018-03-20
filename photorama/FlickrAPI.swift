//
//  FlickrAPI.swift
//  photorama
//
//  Created by Peter Gorgone on 3/19/18.
//  Copyright © 2018 Peter S Gorgone. All rights reserved.
//

import Foundation

// possible errors for Flickr API
enum FlickrError: Error {
    case invalidJSONData
}

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
    
    // Convert Data instance into basic foundation objects
    static func photos(fromJSON data: Data) -> PhotosResult {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
            
            // extract array of dictionaries representing individual photos from JSON data
            guard
            let jsonDictionary = jsonObject as? [AnyHashable:Any],
            let photos = jsonDictionary["photos"] as? [String:Any],
            let photosArray = photos["photo"] as? [[String:Any]] else {
                // json struct doesn't match expecations
                return .failure(FlickrError.invalidJSONData)
            }

            var finalPhotos = [Photo]()
            
            // Parse dictionaries into Photo instances, return as part of 'success' enumerator
            for photoJSON in photosArray {
                if let photo = photo(fromJSON: photoJSON) {
                    finalPhotos.append(photo)
                }
            }
            
            if finalPhotos.isEmpty && !photosArray.isEmpty {
                // not able to parse any photos, json format has possible changed, etc
                return .failure(FlickrError.invalidJSONData)
            }
            
            return .success(finalPhotos)
            
        } catch let error {
            return .failure(error)
        }
    }
    
    // Parse Photo instance from JSON dictionary
    private static func photo(fromJSON json: [String:Any] ) -> Photo? {
        guard
        let photoID = json["id"] as? String,
        let title = json["title"] as? String,
        let dateString = json["datetaken"] as? String,
        let photosURLString = json["url_h"] as? String,
        let url = URL(string: photosURLString),
        let dateTaken = dateFormatter.date(from: dateString) else {
            return nil; // not enough info to construct photo
        }
        return Photo(title: title, photoID: photoID, remoteURL: url, dateTaken: dateTaken)
    }
    
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
    
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()
    
}

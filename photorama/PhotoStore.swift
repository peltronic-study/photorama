//
//  PhotoStore.swift
//  photorama
//
//  Created by Peter Gorgone on 3/19/18.
//  Copyright © 2018 Peter S Gorgone. All rights reserved.
//

import Foundation

class PhotoStore {
    
    // property to hold an instance of URLSession
    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    // creates a URLRequest that connects to flickr api and asks for list of interesting photos
    func fetchInterestingPhotos() {
        let url = FlickrAPI.interestingPhotosURL
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) { (data,response,error) -> Void in
            // completion closure for the session, called when request finishes
            if let jsonData = data {
                if let jsonString = String(data: jsonData, encoding: .utf8) {
                    print(jsonString)
                }
            } else if let requestError = error {
                print("Error fetching photos : \(requestError)")
            } else {
                print("Unexpected error with the request")
            }
        }
        task.resume()
    }
    
    
}

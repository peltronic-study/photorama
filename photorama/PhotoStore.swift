//
//  PhotoStore.swift
//  photorama
//
//  Created by Peter Gorgone on 3/19/18.
//  Copyright © 2018 Peter S Gorgone. All rights reserved.
//

import Foundation

// valid JSON data containing an array of phots will be associated with the success case
enum PhotosResult {
    case success([Photo])
    case failure(Error)
}

class PhotoStore {
    
    // property to hold an instance of URLSession
    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    // creates a URLRequest that connects to flickr api and asks for list of interesting photos
    // uses completion closure that will be called once web service request is completed
    func fetchInterestingPhotos(completion: @escaping (PhotosResult) -> Void) {
        let url = FlickrAPI.interestingPhotosURL
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) { (data,response,error) -> Void in
            // completion closure for the session, called when request finishes
            let result = self.processPhotosRequest(data: data, error: error)
            completion(result)
        }
        task.resume()
    }
    
    // porcess JSOn data returend from web service request
    private func processPhotosRequest(data: Data?, error: Error?) -> PhotosResult {
        guard let jsonData = data else {
            return .failure(error!)
        }
        return FlickrAPI.photos(fromJSON: jsonData)
    }

}

//
//  PhotoStore.swift
//  photorama
//
//  Created by Peter Gorgone on 3/19/18.
//  Copyright © 2018 Peter S Gorgone. All rights reserved.
//

import UIKit

enum ImageResult {
    case success(UIImage) // will have image associated if download is successful
    case failure(Error)
}

enum PhotoError: Error {
    case imageCreationError
}

// valid JSON data containing an array of phots will be associated with the success case
enum PhotosResult {
    case success([Photo])
    case failure(Error)
}

class PhotoStore {
    
    // %NOTE: Completion handlers should be called on the *main thread* (aka UI thread)
    //   ~ by default, URLSessionDataTask runs the completion handler on a background thread,
    //     force it to run on main thread using OperationQueue class
    
    // property to hold an instance of URLSession
    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    // download image data
    func fetchImage(for photo: Photo, completion: @escaping (ImageResult) -> Void) {
        let photoURL = photo.remoteURL
        let request = URLRequest(url: photoURL)
        
        let task = session.dataTask(with: request) { (data, response, error) -> Void in
            
            let result = self.processImageRequest(data: data, error: error)
            OperationQueue.main.addOperation {
                completion(result)
            }
        }
        task.resume()
    }
    
    // creates a URLRequest that connects to flickr api and asks for list of interesting photos
    // uses completion closure that will be called once web service request is completed
    func fetchInterestingPhotos(completion: @escaping (PhotosResult) -> Void) {
        let url = FlickrAPI.interestingPhotosURL
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) { (data,response,error) -> Void in
            // completion closure for the session, called when request finishes
            let result = self.processPhotosRequest(data: data, error: error)
            OperationQueue.main.addOperation {
                completion(result)
            }
        }
        task.resume()
    }
    
    // process data from we service into an image
    private func processImageRequest(data: Data?, error: Error?) -> ImageResult {
        guard
            let imageData = data,
            let image = UIImage(data: imageData)
            else {
                if data == nil {
                    return .failure(error!)
                } else {
                    return .failure(PhotoError.imageCreationError)
                }
        }
        return .success(image)
    }
    
    // porcess JSOn data returend from web service request
    private func processPhotosRequest(data: Data?, error: Error?) -> PhotosResult {
        guard let jsonData = data else {
            return .failure(error!)
        }
        return FlickrAPI.photos(fromJSON: jsonData)
    }

}

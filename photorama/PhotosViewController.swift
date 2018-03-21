//
//  PhotosViewController.swift
//  photorama
//
//  Created by Peter Gorgone on 3/19/18.
//  Copyright © 2018 Peter S Gorgone. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController {
    
    @IBOutlet var collectionView: UICollectionView!
    
    // This controller makes requests by calling methods on PhotoStore, so we need an instance of it...
    //   ~ store is a dependency of of this controller...use property injection to set the dependency
    var store: PhotoStore!
    let photoDataSource = PhotoDataSource()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // set data source on the view
        collectionView.dataSource = photoDataSource
        
        // kick off web service exchagne when view controllers comes on screen for first time
        store.fetchInterestingPhotos { (PhotosResult) -> Void in
            switch PhotosResult {
            case let .success(photos):
                print("Successfully found \(photos.count) photos")
                // update with result of web service request
                self.photoDataSource.photos = photos
            case let .failure(error):
                print("Error fetching interesting photos: \(error)")
                self.photoDataSource.photos.removeAll()
            }
            
        }
    }
    
    /*
    // fetch image and display on image view, called in viewDidLoad
    func updateImageView(for photo: Photo) {
        store.fetchImage(for: photo) { (imageResult) -> Void in
            switch imageResult {
            case let .success(image):
                self .imageView.image = image
            case let .failure(error):
                print("Error downloading image: \(error)")
            }
        }
    }
 */
    
}

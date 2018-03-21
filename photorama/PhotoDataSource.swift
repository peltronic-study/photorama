//
//  PhotoDataSource.swift
//  photorama
//
//  Created by Peter Gorgone on 3/21/18.
//  Copyright © 2018 Peter S Gorgone. All rights reserved.
//

import UIKit

class PhotoDataSource: NSObject, UICollectionViewDataSource {
    
    var photos = [Photo]()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("PhotoDataSource.collectionView(numberOfItemsInSection), photos.count = \(photos.count)")
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("PhotoDataSource.collectionView(cellForItemAt)")
        let identifier = "PhotoCollectionViewCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! PhotoCollectionViewCell
        return cell
    }
}


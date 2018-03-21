//
//  PhotoCollectionViewCell.swift
//  photorama
//
//  Created by Peter Gorgone on 3/21/18.
//  Copyright © 2018 Peter S Gorgone. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    // reset cell to spinning state when cell is first created
    override func awakeFromNib() {
        super.awakeFromNib()
        update(with: nil)
    }
    
    // reset cell to spinning state when cell is getting re-used
    override func prepareForReuse() {
        super.prepareForReuse()
        update(with: nil)
    }
    
    // Activity indicator should only spin when cell is not displaying an image (ie, while downloading)
    func update(with image: UIImage?) {
        if let imageToDisplay = image {
            spinner.stopAnimating()
            imageView.image = imageToDisplay
        } else {
            spinner.startAnimating()
            imageView.image = nil
        }
    }
}

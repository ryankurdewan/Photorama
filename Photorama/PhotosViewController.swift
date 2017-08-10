//
//  PhotosViewController.swift
//  Photorama
//
//  Created by Ryan Kurdewan on 8/9/17.
//  Copyright © 2017 Ryan Kurdewan. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    var store: PhotoStore!
    override func viewDidLoad() {
        super.viewDidLoad()
        store.fetchInterestingPhotos {
            (photosResult) -> Void in
            switch photosResult {
                case let .success(photos):
                    print("Successfully found \(photos.count) photos.")
                    if let firstPhoto = photos.first {
                        self.updateImageView(for: firstPhoto)
                }
                case let .failure(error):
                    print("Error fetching interesting photos: \(error)")
            }
        }
    }
    func updateImageView(for photo: Photo) {
        store.fetchImage(for: photo) {
            (imageResult) -> Void in
            switch imageResult {
            case let .success(image):
                OperationQueue.main.addOperation {
                    self.imageView.image = image
                }
            case let .failure(error):
                print("Error downloading image: \(error)")
            }
        }
    }
}

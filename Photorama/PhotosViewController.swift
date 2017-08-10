//
//  PhotosViewController.swift
//  Photorama
//
//  Created by Ryan Kurdewan on 8/9/17.
//  Copyright © 2017 Ryan Kurdewan. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController, UICollectionViewDelegate {
    @IBOutlet var collectionView: UICollectionView!
    let photoDataSource = PhotoDataSource()
    var store: PhotoStore!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        collectionView.dataSource = photoDataSource
        collectionView.delegate = self
        store.fetchInterestingPhotos
            {
            (photosResult) -> Void in
            switch photosResult
            {
                case let .success(photos):
                    print("Successfully found \(photos.count) photos.")
                    self.photoDataSource.photos = photos
                case let .failure(error):
                    print("Error fetching interesting photos: \(error)")
                    self.photoDataSource.photos.removeAll()
            }
            self.collectionView.reloadSections(IndexSet(integer: 0))
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showPhoto"?:
            if let selectedIndexPath = collectionView.indexPathsForSelectedItems?.first {
                let photo = photoDataSource.photos[selectedIndexPath.row]
                let destinationVC = segue.destination as! PhotoInfoViewController
                destinationVC.photo = photo
                destinationVC.store = store
            }
        default:
            preconditionFailure("Unexpected segue identifier.")
        }
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath)
    {
        let photo = photoDataSource.photos[indexPath.row]
        // download the image data
        store.fetchImage(for: photo)
        { (result) -> Void in
            guard let photoIndex = self.photoDataSource.photos.index(of: photo),
                case let .success(image) = result else
            {
                    return
            }
            let photoIndexPath = IndexPath(item: photoIndex, section: 0)
            // only update if cell is still visible
            if let cell = self.collectionView.cellForItem(at: photoIndexPath) as? PhotoCollectionViewCell
            {
                cell.update(with: image)
            }
        }
    }
}

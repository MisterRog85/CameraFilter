//
//  PhotosCollectionViewController.swift
//  CameraFilter
//
//  Created by William Tomas on 25/09/2019.
//  Copyright © 2019 William Tomas. All rights reserved.
//

import Foundation
import UIKit
import Photos
import RxSwift

class PhotosCollectionViewController: UICollectionViewController {
    
    private let selectedPhotoSubject = PublishSubject<UIImage>() //variable qui contiendra la photo sélecitonnée
    
    var selectedPhoto: Observable<UIImage> { //observable pour la sélection de photo
        return selectedPhotoSubject.asObservable()
    }
    
    private var images = [PHAsset]() //PHAssets -> représentation d'une image de la galerie
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populatePhotos() //charger les photos de la galerie
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count
    }
    
    //on créé la vue grille
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as? PhotosCollectionViewCell else {
            fatalError("PhotoCollectionViewCell not found")
        }
        
        let asset = self.images[indexPath.row]
        
        let manager = PHImageManager.default()
        
        manager.requestImage(for: asset, targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFit, options: nil) { image, _ in
            DispatchQueue.main.async {
                cell.photoImageView.image = image
            }
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedAsset = self.images[indexPath.row]
        PHImageManager.default().requestImage(for: selectedAsset, targetSize: CGSize(width: 300, height: 300), contentMode: .aspectFit, options: nil) { [weak self] image, info in
            //on vérifie qu'on ne sélectionne pas la miniature
            guard let info = info else { return }
            
            let isDegradedImage = info["PHImageResultIsDegradedKey"] as! Bool
            
            if !isDegradedImage {
                if let image = image {
                    self?.selectedPhotoSubject.onNext(image) //on ajoute ici notre image à notre observable/sujet
                    self?.dismiss(animated: true, completion: nil)
                }
                
            }
            
        }
    }
    
    private func populatePhotos() {
        PHPhotoLibrary.requestAuthorization { [weak self] status in //weak self pour éviter les débordements de mémoire
            if status == .authorized {
                //on accède à la galerie
                let assets = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: nil)
                
                assets.enumerateObjects { (object, count, stop) in //on ajoute les photos de la galerie à nos cellules
                    self?.images.append(object)
                }
                
                self?.images.reverse() //images plus récentes au dessus
                DispatchQueue.main.async {
                    self?.collectionView.reloadData() //rechargement en asynchrone
                }
                
                
            }
        }
    }
}

//
//  ViewController.swift
//  CameraFilter
//
//  Created by William Tomas on 25/09/2019.
//  Copyright © 2019 William Tomas. All rights reserved.
//

import UIKit
import RxSwift

class ViewController: UIViewController {
    
    @IBOutlet weak var applyFilterButton: UIButton!
    @IBOutlet weak var photoImageView: UIImageView!
    
    let disposeBag = DisposeBag() //supprime la subscription une fois la photo passée

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.prefersLargeTitles = true //pour avoir le titre du navigationController en grand
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) { //fonction appelée lorsque la transition est faite
        guard let navC = segue.destination as? UINavigationController, //segue = terme pour navigation
              let photosCVC = navC.viewControllers.first as? PhotosCollectionViewController
            else {
                fatalError("Destination non trouvée")
        }
        
        photosCVC.selectedPhoto.subscribe(onNext: { [weak self] photo in //on s'abonne ici
            
            DispatchQueue.main.async {
                self?.updateUI(with: photo)
            }
        }).disposed(by: disposeBag)
    }
    
    @IBAction func applyFilterButtonPressed() {
        
        guard let sourceImage = self.photoImageView.image else {
            return
        }
        
//        FiltersService().applyFilter(to: sourceImage) { filteredImage in
//            DispatchQueue.main.async {
//                self.photoImageView.image = filteredImage
//            }
//        }
        
        FiltersService().applyFilter(to: sourceImage)
            .subscribe(onNext: { filteredImage in
                DispatchQueue.main.async {
                    self.photoImageView.image = filteredImage
                }
            }).disposed(by: disposeBag)
    }
    
    private func updateUI(with image: UIImage) {
        self.photoImageView.image = image //on affecte la photo sélectionnée à notre emplacement ici
        self.applyFilterButton.isHidden = false
    }

}


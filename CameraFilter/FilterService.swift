//
//  FilterService.swift
//  CameraFilter
//
//  Created by William Tomas on 26/09/2019.
//  Copyright © 2019 William Tomas. All rights reserved.
//

import Foundation
import UIKit
import CoreImage
import RxSwift

class FiltersService {
    private var context: CIContext //context pour pouvoir créer des images ou en modifier
    
    init() {
        self.context = CIContext()
    }
    
    func applyFilter(to inputImage: UIImage) -> Observable<UIImage> { //fonction observable qu'on appel de l'extérieur
        
        return Observable<UIImage>.create { observer in
            self.applyFilter(to: inputImage) { filteredImage in
                observer.onNext(filteredImage)
            }
            return Disposables.create()
        }
        
        
    }
    
    private func applyFilter(to inputImage: UIImage, completion: @escaping((UIImage) -> ())) { //fonciton privée propre à la classe qui fait les modifications
        
        let filter = CIFilter(name: "CICMYKHalftone")!
        filter.setValue(5.0, forKey: kCIInputWidthKey) //définition du filtre et des paramètres
        
        if let sourceImage = CIImage(image: inputImage) {
            filter.setValue(sourceImage, forKey: kCIInputImageKey)
            
            if let cgimg = self.context.createCGImage(filter.outputImage!, from: filter.outputImage!.extent) {
                
                let processedImage = UIImage(cgImage: cgimg, scale: inputImage.scale, orientation: inputImage.imageOrientation)
                
                completion(processedImage) //renvoyé l'image traitée
            }
        }
        
    }
}

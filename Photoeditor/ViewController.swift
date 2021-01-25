//
//  ViewController.swift
//  Photoeditor
//
//  Created by Александр Беляев on 25.01.2021.
//

import UIKit
import CoreImage

class ViewController: UIViewController {
    
    @IBOutlet weak var sourceImage: UIImageView!
    @IBOutlet weak var rotateButton: UIButton!
    @IBOutlet weak var invertColorsButton: UIButton!
    @IBOutlet weak var mirrorImageButton: UIButton!
    
    @IBAction func doRotate(_ sender: Any) {
        sourceImage.transform = sourceImage.transform.rotated(by: .pi/4)
    }
    
    @IBAction func doInvertColors(_ sender: Any) {
        if let image = sourceImage.image {
            sourceImage.image = image.grayscaleImage()
        }
    }
    
    @IBAction func doMirrorImage(_ sender: Any) {
        if let image = sourceImage.image {
            sourceImage.image = image.withHorizontallyFlippedOrientation()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
}

extension UIImage {
    func grayscaleImage() -> UIImage {
        if let ciImage = CoreImage.CIImage(image: self, options: nil) {
            let paramsColor: [String : AnyObject] = [ kCIInputSaturationKey: NSNumber(value: 0.0) ]

            let grayscale = ciImage.applyingFilter("CIColorControls", parameters: paramsColor)
            
            if let processedCGImage = CIContext().createCGImage(grayscale, from: grayscale.extent) {
                return UIImage(cgImage: processedCGImage, scale: self.scale, orientation: self.imageOrientation)
            }
        }
        return UIImage()
    }
}

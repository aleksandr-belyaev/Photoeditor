//
//  ViewController.swift
//  Photoeditor
//
//  Created by Александр Беляев on 25.01.2021.
//

import UIKit

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
            sourceImage.image = invertColors(image: image)
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

    
    func invertColors(image: UIImage) -> UIImage {
        if let sourceImage = CIImage(image: image) {
            if let inversionFilter = CIFilter(name: "CIColorInvert") {
                inversionFilter.setValue(sourceImage, forKey: kCIInputImageKey)
                return UIImage(ciImage: inversionFilter.outputImage!)
            }
        }
        return UIImage()
    }

}


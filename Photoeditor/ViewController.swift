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
        sourceImage.transform = sourceImage.transform.rotated(by: .pi)
    }
    
    @IBAction func doInvertColors(_ sender: Any) {
    }
    
    @IBAction func doMirrorImage(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }


}


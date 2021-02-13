//
//  ViewController.swift
//  Photoeditor
//
//  Created by Александр Беляев on 25.01.2021.
//

import UIKit
import CoreImage

class ViewController: UIViewController {
    
    weak var editorStackView: UIStackView!
    weak var sourceImageView: UIImageView!
    weak var editButtonOne: UIButton!
    
    override func loadView() {
        super.loadView()
        
        let editorStackView = UIStackView(frame: .zero)
        editorStackView.translatesAutoresizingMaskIntoConstraints = false
        editorStackView.backgroundColor = .gray
        editorStackView.axis = .vertical
        editorStackView.alignment = .fill
        editorStackView.distribution = .fill
        editorStackView.spacing = 10
        
        let sourceImageView = UIImageView(frame: .zero)
        sourceImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let editButtonOne = UIButton(type: .roundedRect)
        editButtonOne.frame = .zero
        editButtonOne.translatesAutoresizingMaskIntoConstraints = false
        editButtonOne.backgroundColor = .green
        editButtonOne.setTitle("Button one", for: .normal)
        editButtonOne.addTarget(self, action: #selector(doRotate), for: .touchUpInside)
        
        editorStackView.addArrangedSubview(sourceImageView)
        editorStackView.addArrangedSubview(editButtonOne)
        self.view.addSubview(editorStackView)
        NSLayoutConstraint.activate(setEditorStackViewConstraints(editorStackView))
        NSLayoutConstraint.activate(setSourceImageConstraints(sourceImageView))
        
        self.editButtonOne = editButtonOne
        self.editorStackView = editorStackView
        self.sourceImageView = sourceImageView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sourceImageView.image = UIImage(named: "nice")
    }
    
    private func setEditorStackViewConstraints(_ view: UIStackView) -> [NSLayoutConstraint] {
        let constraints: [NSLayoutConstraint] = [
            view.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10),
            view.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            view.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -10)
        ]
        return constraints
    }
    
    private func setSourceImageConstraints(_ view: UIImageView) -> [NSLayoutConstraint] {
        let constraints: [NSLayoutConstraint] = [
            view.widthAnchor.constraint(equalToConstant: 150),
            view.widthAnchor.constraint(equalTo: view.heightAnchor),
        ]
        return constraints
    }
    
    @objc func doRotate(_ sender: UIButton) {
        sourceImageView.transform = sourceImageView.transform.rotated(by: .pi/2)
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




//    @IBOutlet weak var sourceImage: UIImageView!
//    @IBOutlet weak var rotateButton: UIButton!
//    @IBOutlet weak var invertColorsButton: UIButton!
//    @IBOutlet weak var mirrorImageButton: UIButton!
//
//
//    @IBAction func doInvertColors(_ sender: Any) {
//        if let image = sourceImage.image {
//            sourceImage.image = image.grayscaleImage()
//        }
//    }
//
//    @IBAction func doMirrorImage(_ sender: Any) {
//        if let image = sourceImage.image {
//            sourceImage.image = image.withHorizontallyFlippedOrientation()
//        }
//    }

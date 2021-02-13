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
    weak var buttonStack: UIStackView!
    weak var rotateButton: UIButton!
    weak var bwButton: UIButton!
    weak var mirrorButton: UIButton!
    
    override func loadView() {
        super.loadView()
        
        //Главный стэк, в котором располагается исходное изображение и стэк с кнопками для его редактирования
        let editorStackView = UIStackView(frame: .zero)
        editorStackView.translatesAutoresizingMaskIntoConstraints = false
        editorStackView.backgroundColor = .gray
        editorStackView.axis = .vertical
        editorStackView.alignment = .fill
        editorStackView.distribution = .fill
        editorStackView.spacing = 10
        
        //Стэк для кнопок
        let buttonStackView = UIStackView(frame: .zero)
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.axis = .horizontal
        buttonStackView.alignment = .fill
        buttonStackView.distribution = .fillProportionally
        buttonStackView.spacing = 5
        
        //Вьюха с исходной картинкой
        let sourceImageView = UIImageView(frame: .zero)
        sourceImageView.translatesAutoresizingMaskIntoConstraints = true
        
        //Кнопка поворота избражения
        let rotateButton = UIButton().createEditButton("Повернуть")
        rotateButton.addTarget(self, action: #selector(doRotateImage), for: .touchUpInside)
        //Кнопка чб режима
        let bwButton = UIButton().createEditButton("Чб")
        bwButton.addTarget(self, action: #selector(doGrayscaleImageColors), for: .touchUpInside)
        //Кнопка отзеркаливания
        let mirrorButton = UIButton().createEditButton("Отзеркалить")
        mirrorButton.addTarget(self, action: #selector(doMirrorImage), for: .touchUpInside)
        
        //Компонуем кнопки всё в стэки и устанавливаем констрэйнты
        editorStackView.addArrangedSubview(sourceImageView)
        editorStackView.addArrangedSubview(buttonStackView)
        buttonStackView.addArrangedSubview(rotateButton)
        buttonStackView.addArrangedSubview(bwButton)
        buttonStackView.addArrangedSubview(mirrorButton)
        self.view.addSubview(editorStackView)
        
        NSLayoutConstraint.activate([
            editorStackView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10),
            editorStackView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            editorStackView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            sourceImageView.widthAnchor.constraint(equalTo: sourceImageView.heightAnchor)
        ])
        
        self.editorStackView = editorStackView
        self.sourceImageView = sourceImageView
        self.buttonStack = buttonStackView
        self.rotateButton = rotateButton
        self.bwButton = bwButton
        self.mirrorButton = mirrorButton
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sourceImageView.image = UIImage(named: "nice")
    }
    
    @objc func doRotateImage(_ sender: UIButton) {
        self.sourceImageView.transform = sourceImageView.transform.rotated(by: .pi/2)
    }
    
    @objc func doGrayscaleImageColors(_ sender: Any) {
        if let image = sourceImageView.image {
            self.sourceImageView.image = image.grayscaleImage()
        }
    }
    
    @objc func doMirrorImage(_ sender: Any) {
        if let image = self.sourceImageView.image {
            self.sourceImageView.image = image.withHorizontallyFlippedOrientation()
        }
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

extension UIButton {
    func createEditButton(_ title: String) -> UIButton {
        let someButton = UIButton(type: .roundedRect)
        someButton.frame = .zero
        someButton.translatesAutoresizingMaskIntoConstraints = false
        someButton.backgroundColor = .green
        someButton.setTitle(title, for: .normal)
        return someButton
    }
}

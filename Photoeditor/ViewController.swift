//
//  ViewController.swift
//  Photoeditor
//
//  Created by Александр Беляев on 25.01.2021.
//

import UIKit
import CoreImage

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    weak var mainStackView: CustomStackView!
    weak var sourceImageView: UIImageView!
    weak var buttonStack: CustomStackView!
    weak var rotateButton: CustomButton!
    weak var bwButton: CustomButton!
    weak var mirrorButton: CustomButton!
    weak var savedImagesView: UICollectionView!
    
    let cellReuseIdentifier = "Cell"
    
    var alert = UIAlertController()
    
    
    override func loadView() {
        super.loadView()
        
        //Главный стэк, в котором располагается исходное изображение и стэк с кнопками для его редактирования
        let mainStackView = CustomStackView(axis: .vertical, distribution: .fill)
        let buttonStackView = CustomStackView(axis: .horizontal, distribution: .fillEqually)
        
        //Вьюха с исходной картинкой
        let sourceImageView = UIImageView(frame: .zero)
        sourceImageView.translatesAutoresizingMaskIntoConstraints = true
        
        //Кнопки редактирования
        let rotateButton = CustomButton(withTitle: "Повернуть")
        rotateButton.addTarget(self, action: #selector(doRotateImage), for: .touchUpInside)
        let bwButton = CustomButton(withTitle: "Чб")
        bwButton.addTarget(self, action: #selector(doGrayscaleImageColors), for: .touchUpInside)
        let mirrorButton = CustomButton(withTitle: "Отзеркалить")
        mirrorButton.addTarget(self, action: #selector(doMirrorImage), for: .touchUpInside)
        
        //Вьюха с сохранёнными картинками
        let savedImagesView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        savedImagesView.translatesAutoresizingMaskIntoConstraints = false
        savedImagesView.backgroundColor = .none
        savedImagesView.register(CollectionViewCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
        
        
        //Компонуем кнопки всё в стэки и устанавливаем констрэйнты
        mainStackView.addArrangedSubview(sourceImageView)
        mainStackView.addArrangedSubview(buttonStackView)
        mainStackView.addArrangedSubview(savedImagesView)
        buttonStackView.addArrangedSubview(rotateButton)
        buttonStackView.addArrangedSubview(bwButton)
        buttonStackView.addArrangedSubview(mirrorButton)
        
        self.view.addSubview(mainStackView)
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10),
            mainStackView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            mainStackView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            sourceImageView.widthAnchor.constraint(equalTo: sourceImageView.heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            savedImagesView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        self.mainStackView = mainStackView
        self.sourceImageView = sourceImageView
        self.buttonStack = buttonStackView
        self.rotateButton = rotateButton
        self.bwButton = bwButton
        self.mirrorButton = mirrorButton
        self.savedImagesView = savedImagesView
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sourceImageView.image = UIImage(named: "nice")
        
        savedImagesView.delegate = self
        savedImagesView.dataSource = self
    }
    
    @objc func doRotateImage(_ sender: UIButton) {
        self.sourceImageView.transform = sourceImageView.transform.rotated(by: .pi/2)
    }
    
    @objc func doGrayscaleImageColors(_ sender: UIButton) {
        if let image = sourceImageView.image {
            self.sourceImageView.image = image.grayscaleImage()
        }
    }
    
    @objc func doMirrorImage(_ sender: UIButton) {
        if let image = self.sourceImageView.image {
            self.sourceImageView.image = image.withHorizontallyFlippedOrientation()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as? CollectionViewCell {
//            let imageName = arrayImages[indexPath.row]
//
//            cell.setImage(imageName: imageName)
            cell.backgroundColor = .purple
            return cell
        }
        return UICollectionViewCell()
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

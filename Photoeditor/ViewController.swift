//
//  ViewController.swift
//  Photoeditor
//
//  Created by Александр Беляев on 25.01.2021.
//

import UIKit
import CoreImage

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    weak var mainStackView: UIStackView!
    weak var sourceImageView: UIImageView!
    weak var buttonStack: UIStackView!
    weak var rotateButton: UIButton!
    weak var bwButton: UIButton!
    weak var mirrorButton: UIButton!
    weak var savedImagesView: UICollectionView!
    
    let cellReuseIdentifier = "Cell"
    
    var alert = UIAlertController()
    
    
    override func loadView() {
        super.loadView()
        
        //Главный стэк, в котором располагается исходное изображение, стэк с кнопками для его редактирования и коллекция для результатов
        let mainStackView = createCustomStackView(axis: .vertical, distribution: .fill)
        let buttonStackView = createCustomStackView(axis: .horizontal, distribution: .fillEqually)
        
        //Вьюха с исходной картинкой
        let sourceImageView = UIImageView(frame: .zero)
        sourceImageView.translatesAutoresizingMaskIntoConstraints = true
        
        //Кнопки редактирования
        let rotateButton = createEditButton(withTitle: "Повернуть", andAction: #selector(doRotateImage))
        let bwButton = createEditButton(withTitle: "Чб", andAction: #selector(doGrayscaleImageColors))
        let mirrorButton = createEditButton(withTitle: "Отзеркалить", andAction: #selector(doMirrorImage))
        
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
    
    func createEditButton(withTitle title: String, andAction action: Selector) -> UIButton {
        let customButton = UIButton(type: .roundedRect)
        customButton.frame = .zero
        customButton.translatesAutoresizingMaskIntoConstraints = false
        customButton.backgroundColor = .green
        customButton.setTitle(title, for: .normal)
        customButton.addTarget(self, action: action, for: .touchUpInside)
        return customButton
    }
    
    func createCustomStackView(axis: NSLayoutConstraint.Axis, distribution: UIStackView.Distribution) -> UIStackView {
        let customStackView = UIStackView(frame: .zero)
        customStackView.translatesAutoresizingMaskIntoConstraints = false
        customStackView.axis = axis
        customStackView.alignment = .fill
        customStackView.distribution = distribution
        customStackView.spacing = 5
        return customStackView
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

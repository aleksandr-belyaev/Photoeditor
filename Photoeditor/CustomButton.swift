//
//  CustomButton.swift
//  Photoeditor
//
//  Created by Александр Беляев on 13.02.2021.
//

import UIKit

class CustomButton: UIButton {

    init(withTitle title: String) {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .green
        self.setTitle(title, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

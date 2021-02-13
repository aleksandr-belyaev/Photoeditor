//
//  CustomStackView.swift
//  Photoeditor
//
//  Created by Александр Беляев on 13.02.2021.
//

import UIKit

class CustomStackView: UIStackView {

    init(axis: NSLayoutConstraint.Axis, distribution: UIStackView.Distribution) {
        super.init(frame: .zero)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.axis = axis
        self.alignment = .fill
        self.distribution = distribution
        self.spacing = 5
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

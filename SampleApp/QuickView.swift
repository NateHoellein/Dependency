//
//  QuickView.swift
//  SampleApp
//
//  Created by Nathan Hoellein on 11/7/21.
//

import UIKit

class QuickView: UIView {
    
    var label: UILabel
    
    init(text: String) {
        
        label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = text
        
        super.init(frame: .zero)
        
        self.addSubview(label)
        self.addConstraints([
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            label.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
            label.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

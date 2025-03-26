//
//  CockroachView.swift
//  RoachReaper
//
//  Created by Danya Polyakov on 26.03.2025.
//

import Foundation
import UIKit


final class CockroachView: UIView {
    private enum Constants {
        static let viewWidth: CGFloat = 60
        static let viewHeight: CGFloat = 80
    }
    
    private let imageView = UIImageView()
    var topConstr: NSLayoutConstraint?
    var leftConstr: NSLayoutConstraint?
    var isSpecial: Bool
    
    let initialX: CGFloat
    let initialY: CGFloat
    
    init(x: CGFloat, y: CGFloat, isSpecial: Bool) {
        self.isSpecial = isSpecial
        self.initialX = x
        self.initialY = y
        
        super.init(frame: .zero)
        
        self.addSubview(self.imageView)
        self.imageView.clipsToBounds = true
        self.imageView.setHeight(Constants.viewHeight)
        self.imageView.setWidth(Constants.viewWidth)
        self.imageView.pinCenterX(to: self)
        self.imageView.pinCenterY(to: self)
        
        if isSpecial == false {
            self.imageView.image = UIImage(named: "Roach")
        } else {
            self.imageView.image = UIImage(named: "Special")
        }
        
        self.setHeight(Constants.viewHeight)
        self.setWidth(Constants.viewWidth)
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//
//  ChooseNMView.swift
//  RoachReaper
//
//  Created by Danya Polyakov on 26.03.2025.
//

import Foundation
import UIKit

final class ChooseView: UIView {
    private enum Constants {
        static let fieldWidth: CGFloat = 280
        static let fieldHeight: CGFloat = 30
        static let NPlaceholder: String = "Enter the time between spawns"
        static let MPlaceHolder: String = "Enter the radius of your strike in pixels"
        static let buttonText: String = "Start the game"
        static let fieldColor: UIColor = .white
        static let labelCornerRad: CGFloat = 10
        static let buttonWidth: CGFloat = 200
        static let buttonHeight: CGFloat = 40
        static let buttonTextColor: UIColor = .white
        static let buttonColor: UIColor = .brown
        static let viewWidth: CGFloat = 300
        static let viewHeight: CGFloat = 100
    }
    
    var start: ((Int, Int) -> Void)?
    
    
    private let textFieldN: UITextField = {
        let tf = UITextField()
        tf.setWidth(Constants.fieldWidth)
        tf.setHeight(Constants.fieldHeight)
        tf.backgroundColor = Constants.fieldColor
        tf.placeholder = Constants.NPlaceholder
        tf.layer.cornerRadius = Constants.labelCornerRad
        return tf
    }()
    
    private let textFieldM: UITextField = {
        let tf = UITextField()
        tf.setWidth(Constants.fieldWidth)
        tf.setHeight(Constants.fieldHeight)
        tf.backgroundColor = Constants.fieldColor
        tf.layer.cornerRadius = Constants.labelCornerRad
        tf.placeholder = Constants.MPlaceHolder
        
        return tf
    }()
    
    private let readyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setHeight(Constants.buttonHeight)
        button.setWidth(Constants.buttonWidth)
        button.setTitle(Constants.buttonText, for: .normal)
        button.setTitleColor(Constants.buttonTextColor, for: .normal)
        button.backgroundColor = Constants.buttonColor
        return button
    }()
    
    init () {
        super.init(frame: .zero)
        self.backgroundColor = .clear
        
        self.setHeight(Constants.viewHeight)
        self.setWidth(Constants.viewWidth)
        
        self.addSubview(textFieldN)
        self.addSubview(textFieldM)
        self.addSubview(readyButton)
        
        textFieldN.pinTop(to: self.topAnchor)
        textFieldN.pinCenterX(to: self.centerXAnchor)
        textFieldM.pinTop(to: textFieldN.bottomAnchor)
        textFieldM.pinCenterX(to: self.centerXAnchor)
        readyButton.pinCenterX(to: self.centerXAnchor)
        readyButton.pinTop(to: textFieldM.bottomAnchor)
        
        readyButton.addTarget(self, action: #selector(buttonPushed), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func disappear() {
        self.textFieldM.isHidden = true
        self.textFieldN.isHidden = true
        self.readyButton.isHidden = true
        self.isHidden = true
    }
    
    func appear() {
        self.textFieldM.isHidden = false
        self.textFieldN.isHidden = false
        self.readyButton.isHidden = false
        self.isHidden = false
    }
    
    @objc func buttonPushed() {
        guard let n = Int(textFieldN.text ?? "5") else {return}
        guard let m = Int(textFieldM.text ?? "30") else {return}
        guard let startFunc = self.start else {return}
        startFunc(n, m)
    }
}

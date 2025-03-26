//
//  GameOverView.swift
//  RoachReaper
//
//  Created by Danya Polyakov on 26.03.2025.
//

import Foundation
import UIKit

final class GameOverView: UIView {
    private enum Constants {
        static let labelWidth: CGFloat = 280
        static let labelHeight: CGFloat = 30
        static let gameOverLabelText: String = "Game over"
        static let killedDefaultText: String = ""
        static let retryButtonText: String = "Retry"
        static let textColor: UIColor = .red
        static let labelColor: UIColor = .clear
        static let labelCornerRad: CGFloat = 10
        static let buttonWidth: CGFloat = 100
        static let buttonHeight: CGFloat = 40
        static let buttonTextColor: UIColor = .white
        static let buttonColor: UIColor = .brown
        static let viewWidth: CGFloat = 300
        static let viewHeight: CGFloat = 100
    }
    
    var retry: (() -> Void)?
    
    private let gameOverLabel: UILabel = {
        let tf = UILabel()
        tf.setWidth(Constants.labelWidth)
        tf.setHeight(Constants.labelHeight)
        tf.backgroundColor = Constants.labelColor
        tf.text = Constants.gameOverLabelText
        tf.textColor = Constants.textColor
        tf.textAlignment = .center
        tf.layer.cornerRadius = Constants.labelCornerRad
        return tf
    }()
    
    private let totalKilledLabel: UILabel = {
        let tf = UILabel()
        tf.setWidth(Constants.labelWidth)
        tf.setHeight(Constants.labelHeight)
        tf.backgroundColor = Constants.labelColor
        tf.text = Constants.killedDefaultText
        tf.textColor = Constants.textColor
        tf.textAlignment = .center
        tf.layer.cornerRadius = Constants.labelCornerRad
        return tf
    }()
    
    private let retryButton: UIButton = {
        let button = UIButton(type: .system)
        button.setHeight(Constants.buttonHeight)
        button.setWidth(Constants.buttonWidth)
        button.setTitle(Constants.retryButtonText, for: .normal)
        button.setTitleColor(Constants.buttonTextColor, for: .normal)
        button.backgroundColor = Constants.buttonColor
        return button
    }()
    
    init () {
        super.init(frame: .zero)
        self.backgroundColor = .clear
        
        
        self.setHeight(Constants.viewHeight)
        self.setWidth(Constants.viewWidth)
        
        self.addSubview(gameOverLabel)
        self.addSubview(totalKilledLabel)
        self.addSubview(retryButton)
        
        gameOverLabel.pinTop(to: self.topAnchor)
        gameOverLabel.pinCenterX(to: self.centerXAnchor)
        totalKilledLabel.pinTop(to: gameOverLabel.bottomAnchor)
        totalKilledLabel.pinCenterX(to: self.centerXAnchor)
        retryButton.pinCenterX(to: self.centerXAnchor)
        retryButton.pinTop(to: totalKilledLabel.bottomAnchor)
        
        retryButton.addTarget(self, action: #selector(buttonPushed), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func disappear() {
        self.gameOverLabel.isHidden = true
        self.totalKilledLabel.isHidden = true
        self.retryButton.isHidden = true
        self.isHidden = true
    }
    
    func appear() {
        self.gameOverLabel.isHidden = false
        self.totalKilledLabel.isHidden = false
        self.retryButton.isHidden = false
        self.isHidden = false
    }
    
    func setKilledNum(killed: String) {
        self.totalKilledLabel.text = killed
    }
    
    @objc func buttonPushed() {
        guard let retry = self.retry else {return}
        retry()
    }
}

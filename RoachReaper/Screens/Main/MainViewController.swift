//
//  MainViewController.swift
//  RoachReaper
//
//  Created by Danya Polyakov on 26.03.2025.
//

import Foundation
import UIKit

protocol MainView: AnyObject {
    func updateKilledLabel(_ killed: Int)
    func updateAliveLabel(_ alive: Int)
    func updateProgressionLabel(_ multiplier: Int)
    func showCockroaches(_ cockroaches: [CockroachView])
    func hideLabels()
    func updateCockroachPosition(_ cockroach: CockroachView, deltaX: CGFloat, deltaY: CGFloat)
    func deleteCockroach(c: CockroachView)
    func gameOver()
}

class ViewController: UIViewController, MainView {
    private enum Constants {
        static let labelHeight: CGFloat = 80
        static let fontSizeSmall: CGFloat = 30
        static let fontSizeBig: CGFloat = 50
        static let fontCol: UIColor = .red
        static let backCol: UIColor = .clear
        static let offset: CGFloat = 5
        static let scale: CGFloat = 1.4
        static let angle: CGFloat = .pi/2
        static let moveAnimationDuration: CGFloat = 0.1
        static let killAnimationDuration: CGFloat = 0.3
        
        static let defaultKillLabelText: String = "KILLED: 0"
        static let defaultAliveLabelText: String = "ALIVE: 0"
        static let defaultProgressionLabelText: String = "X1"
        
        static let minRot: CGFloat = -.pi/2
        static let maxRot: CGFloat = .pi/2
    }
    
    private let killedLabel: UILabel = {
        let l = UILabel()
        l.backgroundColor  = Constants.backCol
        l.text = Constants.defaultKillLabelText
        l.font = UIFont.systemFont(ofSize: Constants.fontSizeSmall)
        l.textColor = Constants.fontCol
        l.setHeight(Constants.labelHeight)
        l.isHidden = true
        return l
    }()
    
    private var aliveLabel: UILabel = {
        let l = UILabel()
        l.text = Constants.defaultKillLabelText
        l.backgroundColor  = Constants.backCol
        l.font = UIFont.systemFont(ofSize: Constants.fontSizeSmall)
        l.textColor = Constants.fontCol
        l.setHeight(Constants.labelHeight)
        l.isHidden = true
        return l
    }()
    
    private var progressionLabel: UILabel = {
        let l = UILabel()
        l.text = Constants.defaultProgressionLabelText
        l.backgroundColor  = Constants.backCol
        l.font = UIFont.systemFont(ofSize: Constants.fontSizeBig)
        l.textColor = Constants.fontCol
        l.setHeight(Constants.labelHeight)
        l.isHidden = true
        return l
    }()
    
    private let chooseView = ChooseView()
    
    private let gameOverView = GameOverView()
    
    var presenter: MainPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "Parquet")
        backgroundImage.contentMode = .scaleAspectFill
        view.addSubview(backgroundImage)
        view.sendSubviewToBack(backgroundImage)
        
        view.addSubview(chooseView)
        chooseView.pinCenterX(to: view.centerXAnchor)
        chooseView.pinCenterY(to: view.centerYAnchor)
        
        view.addSubview(gameOverView)
        gameOverView.disappear()
        gameOverView.pinCenterX(to: view.centerXAnchor)
        gameOverView.pinCenterY(to: view.centerYAnchor)
        
        gameOverView.retry = startGame
        
        
        guard let f = self.presenter?.startGame else {return}
        chooseView.start = f
        
        view.addSubview(killedLabel)
        killedLabel.pinTop(to: view.safeAreaLayoutGuide.topAnchor)
        killedLabel.pinRight(to: view.trailingAnchor, Constants.offset)
        killedLabel.bringSubviewToFront(view)
        
        view.addSubview(aliveLabel)
        aliveLabel.pinTop(to: view.safeAreaLayoutGuide.topAnchor)
        aliveLabel.pinLeft(to: view.leadingAnchor, Constants.offset)
        aliveLabel.bringSubviewToFront(view)
        
        view.addSubview(progressionLabel)
        progressionLabel.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor)
        progressionLabel.pinLeft(to: view.leadingAnchor)
        progressionLabel.bringSubviewToFront(view)
    }
    
    func updateKilledLabel(_ killed: Int) {
        killedLabel.text = "KILLED: \(killed)"
    }
    
    func updateAliveLabel(_ alive: Int) {
        aliveLabel.text = "ALIVE: \(alive)"
    }
    
    func updateProgressionLabel(_ multiplier: Int) {
        progressionLabel.text = "X\(multiplier)"
    }
    
    func showCockroaches(_ cockroaches: [CockroachView]) {
        
        for i in cockroaches {
            view.addSubview(i)
            if i.topConstr != nil {
                continue
            } else {
                i.topConstr = i.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: i.initialY)
                i.leftConstr = i.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: i.initialX)
                
                guard let cT = i.topConstr, let cL = i.leftConstr else {return}
                NSLayoutConstraint.activate([cT, cL])
            }
        }
    }
    
    func startGame() {
        killedLabel.isHidden = true
        aliveLabel.isHidden = true
        progressionLabel.isHidden = true
        chooseView.appear()
        gameOverView.disappear()
        view.bringSubviewToFront(chooseView)
    }
    
    func hideLabels() {
        killedLabel.isHidden = false
        aliveLabel.isHidden = false
        progressionLabel.isHidden = false
        chooseView.isHidden = true
    }
    
    func gameOver() {
        killedLabel.isHidden = true
        aliveLabel.isHidden = true
        progressionLabel.isHidden = true
        chooseView.isHidden = true
        gameOverView.appear()
        view.bringSubviewToFront(gameOverView)
        gameOverView.setKilledNum(killed: self.killedLabel.text ?? "")
    }
    
    func updateCockroachPosition(_ cockroach: CockroachView, deltaX: CGFloat, deltaY: CGFloat) {
        guard let leftConstr = cockroach.leftConstr, let topConstr = cockroach.topConstr else { return }
        
        
        leftConstr.constant += deltaX
        topConstr.constant += deltaY
        UIView.animate(withDuration: Constants.moveAnimationDuration, animations: {
            cockroach.frame.origin.x += deltaX
            cockroach.frame.origin.y += deltaY
            let rot = CGFloat.random(in: Constants.minRot...Constants.maxRot)
            cockroach.transform = CGAffineTransform(rotationAngle: rot)
            cockroach.layoutIfNeeded()
        })
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for i in touches {
            let coords = i.location(in: view)
            presenter?.handleTouch(at: coords)
        }
    }
    
    func deleteCockroach(c: CockroachView) {
        UIView.animate(withDuration: Constants.killAnimationDuration, animations: {
            c.alpha = 0
            c.transform = CGAffineTransform(rotationAngle: .pi/2).scaledBy(x: Constants.scale, y: Constants.scale)
            
        }, completion: {_ in c.removeFromSuperview()})
        
    }
}

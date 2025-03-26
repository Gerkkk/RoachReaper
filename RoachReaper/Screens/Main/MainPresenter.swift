//
//  MainPresenter.swift
//  RoachReaper
//
//  Created by Danya Polyakov on 26.03.2025.
//

import Foundation
import UIKit

class MainPresenter {
    private enum Constatnts {
        static let killAnimationDuration: TimeInterval = 0.3
        static let MoveAnimationCoolDown: TimeInterval = 0.3
        static let minDelta = CGFloat(-50)
        static let maxDelta = CGFloat(50)
        static let insectWidth = CGFloat(30)
        static let insectHeight = CGFloat(60)
    }
    
    private weak var view: MainView?
    private var model: MainModel
    private var addCockroachesTimer: Timer?
    private var moveCockroachesTimer: Timer?
    
    init(view: MainView, model: MainModel) {
        self.view = view
        self.model = model
    }
    
    func startGame(n: Int, m: Int) {
        view?.hideLabels()
        startTimers(n: n, m: m)
    }
    
    private func startTimers(n: Int, m: Int) {
        model.radius = CGFloat(m)
        self.addCockroachesTimer = Timer.scheduledTimer(withTimeInterval: TimeInterval(n), repeats: true) { [weak self] _ in
            self?.addCockroaches()
        }
        
        self.moveCockroachesTimer = Timer.scheduledTimer(withTimeInterval: Constatnts.MoveAnimationCoolDown, repeats: true) { [weak self] _ in
            self?.moveCockroaches()
        }
        
        guard let t = addCockroachesTimer else {return}
        t.fire()
        guard let t = moveCockroachesTimer else {return}
        t.fire()
    }
    
    private func addCockroaches() {
        let q = model.newQ * model.mult
        model.addCockroaches(count: q)
        view?.showCockroaches(model.cockroaches)
        
        let res = model.stopGame()
        
        if res == true {
            self.stopTimers()
            for i in self.model.cockroaches {
                self.view?.deleteCockroach(c: i)
            }
            
            self.model.cockroaches = []
            
            self.view?.gameOver()
        }
        
        view?.updateKilledLabel(model.killed)
        view?.updateAliveLabel(model.cockroaches.count)
    }
    
    private func moveCockroaches() {
        for cockroach in model.cockroaches {
            let deltaX = CGFloat.random(in: Constatnts.minDelta...Constatnts.maxDelta)
            let deltaY = CGFloat.random(in: Constatnts.minDelta...Constatnts.maxDelta)
            view?.updateCockroachPosition(cockroach, deltaX: deltaX, deltaY: deltaY)
        }
    }
    
    func handleTouch(at point: CGPoint) {
        var deletion: [Int] = []
        var delViews: [CockroachView] = []
        
        for (index, insect) in model.cockroaches.enumerated() {
            let x = insect.frame.origin.x + Constatnts.insectWidth / 2
            let y = insect.frame.origin.y + Constatnts.insectHeight / 2
            let dist = sqrt(pow(x - point.x, 2) + pow(y - point.y, 2))
            
            if dist < model.radius {

                deletion.append(index)
                view?.updateProgressionLabel(model.increaseMult())
            }
        }
        
        
        for index in deletion {
            let del = model.cockroaches[index]
            delViews.append(del)
            view?.deleteCockroach(c: del)
        }
        
        DispatchQueue.main.async { [weak self] in
            Thread.sleep(forTimeInterval: Constatnts.killAnimationDuration)
            
            for i in delViews {
                if let index = self?.model.cockroaches.firstIndex(of: i) {
                    self?.model.killCockroach(at: index)
                }
            }
            
            guard let t = self?.model else {return}
            
            self?.view?.updateKilledLabel(t.killed)
            self?.view?.updateAliveLabel(t.cockroaches.count)
        }
    }
    
    func stopTimers() {
        guard let t = addCockroachesTimer else {return}
        t.invalidate()
        addCockroachesTimer = nil
        guard let t = moveCockroachesTimer else {return}
        t.invalidate()
        moveCockroachesTimer = nil
    }
}

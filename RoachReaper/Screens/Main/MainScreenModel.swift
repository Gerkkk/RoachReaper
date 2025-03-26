//
//  MainScreenModel.swift
//  RoachReaper
//
//  Created by Danya Polyakov on 26.03.2025.
//

import Foundation
import UIKit

class MainModel {
    private enum Constants {
        static let initialMult: Int = 1
        static let initialKilled: Int = 0
        static let defaultRadius: CGFloat = 0
        static let numberNewInsects: Int = 5
        static let power10L: Int = 1
        static let maxXOffset: CGFloat = 400
        static let maxYOffset: CGFloat = 800
        static let numberBeforeSpecial: Int = 5
        static let costRegular: Int = 1
        static let costSpecial: Int = 5
        static let muttiplicationCoeffDelta: Int = 1
    }
    
    
    var cockroaches: [CockroachView] = []
    var mult: Int = Constants.initialMult
    var killed: Int = Constants.initialKilled
    var radius: CGFloat = Constants.defaultRadius
    var newQ: Int = Constants.numberNewInsects
    var pow10L: Int = Constants.power10L
    
    func addCockroaches(count: Int) {
        for i in 1...count {
            let x = CGFloat.random(in: 0...Constants.maxXOffset)
            let y = CGFloat.random(in: 0...Constants.maxYOffset)
            
            let r: CockroachView?
            if (killed + i) % Constants.numberBeforeSpecial == 0 {
                r = CockroachView(x: x, y: y, isSpecial: true)
            } else  {
                r = CockroachView(x: x, y: y, isSpecial: false)
            }
            
            guard let rr = r else {return}
                
            
            cockroaches.append(rr)
        }
    }
    
    func stopGame() -> Bool {
        if Decimal(cockroaches.count) >= pow(10, pow10L) {
            mult = Constants.initialMult
            killed = Constants.initialKilled
            radius = Constants.defaultRadius
            pow10L = Constants.power10L
            return true
        } else {
            return false
        }
    }
    
    func killCockroach(at index: Int) {
        if cockroaches.indices.contains(index) {
            let toRemove = cockroaches[index]
            
            if toRemove.isSpecial {
                killed += Constants.costSpecial
            } else {
                killed += Constants.costRegular
            }
            
            cockroaches.remove(at: index)
        }
    }
    
    func increaseMult() -> Int {
        if Decimal(killed) >= pow(10, pow10L) {
            mult += Constants.muttiplicationCoeffDelta
            pow10L += 1
        }
        return mult
    }
}

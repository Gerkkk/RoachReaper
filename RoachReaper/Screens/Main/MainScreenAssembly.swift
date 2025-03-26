//
//  MainScreenAssembly.swift
//  RoachReaper
//
//  Created by Danya Polyakov on 26.03.2025.
//

import Foundation
import UIKit

enum MainScreenAssembly {
    static func build() -> UIViewController {
        let view = ViewController()
        let model = MainModel()
        let presenter = MainPresenter(view: view, model: model)
        view.presenter = presenter
        return view
    }
}

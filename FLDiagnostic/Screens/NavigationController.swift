//
//  NavigationController.swift
//  Forward Leasing
//
//  Created by Kirirushi on 03.12.2019.
//  Copyright © 2019 Arcsinus. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {
    var currentTestNumber = 1

    override func viewDidLoad() {
        super.viewDidLoad()
      
        navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont.proximaNova(size: 20, weight: .light)
            ]
    }
}

//
//  UIAlertController+Extensions.swift
//  FLDiagnostic
//
//  Created by Kirirushi on 07.02.2020.
//  Copyright © 2020 Arcsinus. All rights reserved.
//

import UIKit

extension UIAlertController{
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
       self.view.tintColor = .black
    }
}

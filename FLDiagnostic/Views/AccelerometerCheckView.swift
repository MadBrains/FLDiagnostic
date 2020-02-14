//
//  AccelerometerCheckView.swift
//  Forward Leasing
//
//  Created by Kirirushi on 03.12.2019.
//  Copyright © 2019 Arcsinus. All rights reserved.
//

import UIKit

class AccelerometerCheckView: UIImageView {
    var isChecked = false {
        didSet {
            drawCurrentState()
        }
    }

    init() {
        super.init(frame: CGRect(origin: .zero, size: .init(width: 70, height: 70)))
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func drawCurrentState() {
        if isChecked {
            DispatchQueue.main.async {
                self.image = UIImage.FLImage("AccelerometerChecked")
            }
        }
    }
}

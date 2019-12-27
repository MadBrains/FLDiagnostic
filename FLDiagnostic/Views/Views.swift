//
//  Views.swift
//  Forward Leasing
//
//  Created by Kirirushi on 04.12.2019.
//  Copyright © 2019 Arcsinus. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedView: UIView {
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0.0
        }
    }
}

@IBDesignable
class ShadowedView: RoundedView {
    @IBInspectable var shadowColor: UIColor = .clear {
        didSet {
            layer.shadowColor = shadowColor.cgColor
        }
    }
    @IBInspectable var shadowOffset: CGSize = .zero {
        didSet {
            layer.shadowOffset = shadowOffset
        }
    }
    @IBInspectable var shadowRadius: CGFloat = .zero {
        didSet {
            layer.shadowRadius = shadowRadius
        }
    }
}

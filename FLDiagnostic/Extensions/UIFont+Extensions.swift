//
//  UIFont+Extensions.swift
//  Forward Leasing
//
//  Created by Данил on 02/12/2019.
//  Copyright © 2019 Arcsinus. All rights reserved.
//

import UIKit

extension UIFont {

  enum ProximaNovaWeight: String {
    case black =  "Black"
    case bold = "Bold"
    case light = "Light"
    case regular = "Regular"
    case semibold = "Semibold"
  }

  static func proximaNova(size: CGFloat, weight: ProximaNovaWeight) -> UIFont {
    //swiftlint:disable:next force_unwrapping
    return UIFont(name: Constant.Fonts.proximaNova + "-\(weight.rawValue)", size: size)!
  }

}

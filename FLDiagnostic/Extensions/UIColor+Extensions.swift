//
//  UIColor+Extensions.swift
//  FLDiagnostic
//
//  Created by Kirirushi on 09.01.2020.
//  Copyright © 2020 Arcsinus. All rights reserved.
//

import UIKit

extension UIColor {
  func image(view: UIView) -> UIImage {
    let size = view.bounds.size
    return UIGraphicsImageRenderer(size: size).image { rendererContext in
      self.setFill()
      rendererContext.fill(CGRect(origin: .zero, size: size))
    }
  }
}

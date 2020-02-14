//
//  UIImage+Extensions.swift
//  FLDiagnostic
//
//  Created by Данил on 14/02/2020.
//  Copyright © 2020 Arcsinus. All rights reserved.
//

import UIKit

extension UIImage {
  static func FLImage(_ name: String) -> UIImage {
    return UIImage(named: name, in: Bundle(for: FLDiagnostic.self), compatibleWith: nil) ?? UIImage()
  }
}

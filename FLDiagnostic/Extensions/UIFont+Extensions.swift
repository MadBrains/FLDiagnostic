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
    return UIFont(name: Constant.Fonts.proximaNova + "-\(weight.rawValue)", size: size)!
  }
  
  public static func loadFonts() {
    loadFont(withName: Constant.Fonts.proximaNova + "-\(ProximaNovaWeight.black.rawValue)")
    loadFont(withName: Constant.Fonts.proximaNova + "-\(ProximaNovaWeight.bold.rawValue)")
    loadFont(withName: Constant.Fonts.proximaNova + "-\(ProximaNovaWeight.light.rawValue)")
    loadFont(withName: Constant.Fonts.proximaNova + "-\(ProximaNovaWeight.regular.rawValue)")
    loadFont(withName: Constant.Fonts.proximaNova + "-\(ProximaNovaWeight.semibold.rawValue)")
  }
  
  private static func loadFont(withName fontName: String) {
    let bundle = Bundle(for: FLDiagnostic.self)
    guard let fontURL = bundle.url(forResource: fontName, withExtension: "ttf"),
      let fontData = try? Data(contentsOf: fontURL) as CFData,
      let provider = CGDataProvider(data: fontData),
      let font = CGFont(provider) else {
        return
    }
    CTFontManagerRegisterGraphicsFont(font, nil)
  }

}

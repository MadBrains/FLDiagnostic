//
//  ScreenTestViewModel.swift
//  Forward Leasing
//
//  Created by Kirirushi on 11.12.2019.
//  Copyright © 2019 Arcsinus. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class ScreenTestViewModel: BaseControllerViewModel {
  var test: Test
  var page: Int

  init(_ test: Test, page: Int) {
    self.test = test
    self.page = page
    super.init()
  }
  
  var currentColorIndex = -1
  let colors = [#colorLiteral(red: 0.1176470588, green: 0.1176470588, blue: 0.1176470588, alpha: 1), #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1), #colorLiteral(red: 0, green: 0, blue: 1, alpha: 1), #colorLiteral(red: 0, green: 1, blue: 0, alpha: 1), #colorLiteral(red: 1, green: 1, blue: 0, alpha: 1), #colorLiteral(red: 0, green: 1, blue: 1, alpha: 1), #colorLiteral(red: 1, green: 0, blue: 1, alpha: 1)]

  func nextColor() -> UIColor? {
      currentColorIndex += 1
      if currentColorIndex >= colors.count {
          return nil
      }
      return colors[currentColorIndex]
  }
  func resetColors() {
      currentColorIndex = -1
  }

  func testFailed() {
    test.isPassed = false
    abortDiagnostik()
  }
}

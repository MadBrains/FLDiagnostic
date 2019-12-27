//
//  VibrationTestViewModel.swift
//  Forward Leasing
//
//  Created by Kirirushi on 17.12.2019.
//  Copyright © 2019 Arcsinus. All rights reserved.
//

import AVKit
import RxCocoa
import RxSwift
import UIKit

class VibrationTestViewModel: BaseControllerViewModel {
  var test: Test
  var page: Int

  init(_ test: Test, page: Int) {
    self.test = test
    self.page = page
    super.init()
  }
  
    func playVibro() {
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
    }
  
    func testFailed() {
      test.isPassed = false
      abortDiagnostik()
   }

   func startNextTest() {
      test.isPassed = true
      showNextTestViewController()
   }
}

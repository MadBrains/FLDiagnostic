//
//  FlashlightTestViewModel.swift
//  Forward Leasing
//
//  Created by Kirirushi on 17.12.2019.
//  Copyright © 2019 Arcsinus. All rights reserved.
//

import AVKit
import RxCocoa
import RxSwift
import UIKit

class FlashlightTestViewModel: BaseControllerViewModel {
  var test: Test
  var page: Int

  init(_ test: Test, page: Int) {
    self.test = test
    self.page = page
    super.init()
  }
  
    func toggleTorch(on: Bool) {
        guard let device = AVCaptureDevice.default(for: AVMediaType.video), device.hasTorch else {
            testFailed()
            return
        }

        do {
            try device.lockForConfiguration()
            device.torchMode = on ? .on : .off
            if on {
                try device.setTorchModeOn(level: AVCaptureDevice.maxAvailableTorchLevel)
            }
            device.unlockForConfiguration()
        } catch {
            testFailed()
        }
    }

    func testFailed() {
      test.isPassed = false
      abortDiagnostik()
   }

  func startNextTest(isSafeArea: Bool = false) {
    test.timeSpent = DiagnosticService.shared.calculateSpentTime()
    test.isPassed = true
    showNextTestViewController()
   }
}

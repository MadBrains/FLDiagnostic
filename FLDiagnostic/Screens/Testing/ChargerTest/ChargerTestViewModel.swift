//
//  ChargerTestViewModel.swift
//  Forward Leasing
//
//  Created by Kirirushi on 09.12.2019.
//  Copyright © 2019 Arcsinus. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class ChargerTestViewModel: BaseControllerViewModel {
  var test: Test
  var page: Int

  init(_ test: Test, page: Int) {
    self.test = test
    self.page = page
    super.init()
  }
  
  enum PlugState {
    case plugedIn
    case plugedOut
  }

  var obs: NSKeyValueObservation?

  func startTest() -> Observable<PlugState> {
      let batteryState = PublishSubject<PlugState>()
      UIDevice.current.isBatteryMonitoringEnabled = true
      let currentBatteryState = UIDevice.current.batteryState
      if currentBatteryState == .charging || currentBatteryState == .full {
          DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
              batteryState.onNext(.plugedIn)
          }
      }
      obs = UIDevice.current.observe(\.batteryState, options: []) { (_, _) in
          let currentBatteryState = UIDevice.current.batteryState
          if currentBatteryState == .charging || currentBatteryState == .full {
              batteryState.onNext(.plugedIn)
          }
          if currentBatteryState == .unplugged {
              batteryState.onNext(.plugedOut)
          }
      }
      return batteryState.asObservable()
  }

  func testFailed() {
    test.isPassed = false
    abortDiagnostik()
  }

  func startNextTest() {
    obs?.invalidate()
    
    test.timeSpent = DiagnosticService.shared.calculateSpentTime()
    test.isPassed = true
    showNextTestViewController()
  }
}

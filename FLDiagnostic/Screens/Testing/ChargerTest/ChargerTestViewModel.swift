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

  let plugState = BehaviorSubject<PlugState>(value: .initial)
  private let disposeBag = DisposeBag()
  
  init(_ test: Test, page: Int) {
    self.test = test
    self.page = page
    super.init()
  }
  
  enum PlugState {
    case initial
    case plugedIn
    case plugedOut
  }

  var obs: NSKeyValueObservation?

  func startTest() {
    NotificationCenter.default.rx.notification(UIDevice.batteryStateDidChangeNotification).subscribe(onNext: { [weak self] (notification) in
      guard let currentState = try? self?.plugState.value() else { return }
      
      let currentBatteryState = UIDevice.current.batteryState
      if (currentBatteryState == .charging || currentBatteryState == .full) && currentState == .initial {
        self?.plugState.onNext(.plugedIn)
      }
      if currentBatteryState == .unplugged && currentState == .plugedIn {
       self?.plugState.onNext(.plugedOut)
      }
    }).disposed(by: disposeBag)

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

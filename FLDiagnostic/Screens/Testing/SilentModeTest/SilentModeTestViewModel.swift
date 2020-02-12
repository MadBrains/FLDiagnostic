//
//  SilentModeTestViewModel.swift
//  Forward Leasing
//
//  Created by Kirirushi on 25.12.2019.
//  Copyright © 2019 Arcsinus. All rights reserved.
//

import Mute
import RxCocoa
import RxSwift

class SilentModeTestViewModel: BaseControllerViewModel {
  var test: Test
  var page: Int
  var isMute: Bool?

  init(_ test: Test, page: Int) {
    self.test = test
    self.page = page
    super.init()
  }
  let disposeBag = DisposeBag()
  var completed: Bool = false

  func startVolumeOffTest() -> Observable<Void> {
    let volume = PublishSubject<Void>()

    Mute.shared.checkInterval = 0
    Mute.shared.alwaysNotify = true
    Mute.shared.notify = { mute in
      if self.isMute == nil {
        self.isMute = mute
      } else if self.isMute != mute {
        self.isMute = mute
        volume.onNext(())
        Mute.shared.isPaused = true
      }
    }
    return volume
  }

  func testFailed() {
    test.isPassed = false
    abortDiagnostik()
  }

  func startNextTest() {
    if completed == true { return }
    completed = true
    
    test.timeSpent = DiagnosticService.shared.calculateSpentTime()
    test.isPassed = true
    showNextTestViewController()
  }
}

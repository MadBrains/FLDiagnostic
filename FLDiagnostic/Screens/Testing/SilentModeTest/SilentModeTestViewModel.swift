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

  init(_ test: Test, page: Int) {
    self.test = test
    self.page = page
    super.init()
  }
  let disposeBag = DisposeBag()
  var completed: Bool = false
  var startSilentModeState = false

  func startVolumeOffTest() -> Observable<Void> {
    let volume = PublishSubject<Void>()

    Mute.shared.checkInterval = 1
    Mute.shared.alwaysNotify = true
    startSilentModeState = Mute.shared.isMute
    Mute.shared.notify = { mute in
      if mute == self.startSilentModeState {
        volume.onNext(())
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
    
    test.isPassed = true
    showNextTestViewController()
  }
}

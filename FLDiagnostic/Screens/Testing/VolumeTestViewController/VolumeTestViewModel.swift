//
//  VolumeUpTestViewModel.swift
//  Forward Leasing
//
//  Created by Kirirushi on 05.12.2019.
//  Copyright © 2019 Arcsinus. All rights reserved.
//

import AVKit
import MediaPlayer
import RxCocoa
import RxSwift
import UIKit

class VolumeTestViewModel: BaseControllerViewModel {
  var test: Test
  var page: Int

  init(_ test: Test, page: Int) {
    self.test = test
    self.page = page
    super.init()
  }
  let disposeBag = DisposeBag()

  enum VolumeButtonType {
    case up
    case down
  }
  var completed: Bool = false
  var obs: NSKeyValueObservation?

  func startVolumeTest() -> Observable<VolumeButtonType> {
    MPVolumeView.setVolume(0.5)
    let volume = PublishSubject<VolumeButtonType>()
    let audioSession = AVAudioSession.sharedInstance()
    do {
      try audioSession.setActive(true, options: AVAudioSession.SetActiveOptions())
    } catch {
      self.testFailed()
      return .error(error)
    }
    let oldVolumeBeforeObserve = audioSession.outputVolume
    obs = audioSession.observe(\.outputVolume, options: [.new, .old]) { (audioSession, change) in
      if var oldVolume = change.oldValue, let newVolume = change.newValue {
        oldVolume = oldVolume == 0 ? oldVolumeBeforeObserve : oldVolume
        if oldVolume < newVolume {
          volume.onNext(.up)
        } else {
          volume.onNext(.down)
        }
      }
    }

    return volume.asObservable()
  }

  func testFailed() {
    test.isPassed = false
    abortDiagnostik()
  }
  
  func startNextTest(isSafeArea: Bool = false) {
    obs?.invalidate()
    test.isPassed = true
    showNextTestViewController()
  }
}

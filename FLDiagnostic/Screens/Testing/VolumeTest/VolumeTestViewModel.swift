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

enum VolumeButtonType {
  case up
  case down
}

class VolumeTestViewModel: BaseControllerViewModel {
  var test: Test
  var page: Int

  init(_ test: Test, page: Int) {
    self.test = test
    self.page = page
    super.init()
  }
  let disposeBag = DisposeBag()

  var completed: Bool = false
  var volume: Float = 0.0
  var volumeChanged = PublishSubject<VolumeButtonType>()

  override func setupModel() {
    super.setupModel()
    
    volume = AVAudioSession.sharedInstance().outputVolume
    NotificationCenter.default.rx.notification(NSNotification.Name(rawValue: volumeNotificationName)).subscribe(onNext: { [weak self] (notification) in
      if let newVolume = notification.userInfo?[volumeParameter] as? Float {
        if self?.volume ?? 0 < newVolume {
          self?.volumeChanged.onNext(.up)
        } else if self?.volume ?? 0 > newVolume {
          self?.volumeChanged.onNext(.down)
        }
        self?.volume = newVolume
      }
    }).disposed(by: disposeBag)
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

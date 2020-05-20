//
//  HeadphonesTestViewModel.swift
//  Forward Leasing
//
//  Created by Kirirushi on 10.12.2019.
//  Copyright © 2019 Arcsinus. All rights reserved.
//

import AVKit
import RxCocoa
import RxSwift
import UIKit

class HeadphonesTestViewModel: BaseControllerViewModel {
  var test: Test
  var page: Int
  
  private var plugState: PlugState = .initial
  
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

  var observer: NSObjectProtocol?

  func startTest() -> Observable<PlugState> {
      let headphonesState = PublishSubject<PlugState>()
      observer = NotificationCenter.default.addObserver(forName: AVAudioSession.routeChangeNotification, object: nil, queue: .main) { [weak self] notification in
          guard let audioRouteChangeReason = notification.userInfo?[AVAudioSessionRouteChangeReasonKey] as? UInt else {
              self?.testFailed()
              return
          }

          switch audioRouteChangeReason {
          case AVAudioSession.RouteChangeReason.newDeviceAvailable.rawValue:
            if self?.plugState != .initial { return }
            headphonesState.onNext(.plugedIn)
            self?.plugState = .plugedIn
          case AVAudioSession.RouteChangeReason.oldDeviceUnavailable.rawValue:
            if self?.plugState != .plugedIn { return }
            headphonesState.onNext(.plugedOut)
            self?.plugState = .plugedOut
          default:
              break
          }
      }
      return headphonesState.asObservable()
  }

  func testFailed() {
    test.isPassed = false
    abortDiagnostik()
  }

  func startNextTest() {
    test.timeSpent = DiagnosticService.shared.calculateSpentTime()
    test.isPassed = true
    NotificationCenter.default.removeObserver(observer as Any)
    showNextTestViewController()
  }
}

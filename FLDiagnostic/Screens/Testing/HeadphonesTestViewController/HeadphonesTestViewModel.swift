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

  init(_ test: Test, page: Int) {
    self.test = test
    self.page = page
    super.init()
  }
  
  enum PlugState {
      case plugedIn
      case plugedOut
  }

  var observer: NSObjectProtocol?

  func startTest() -> Observable<PlugState> {
      let headphonesState = PublishSubject<PlugState>()
      observer = NotificationCenter.default.addObserver(forName: AVAudioSession.routeChangeNotification, object: nil, queue: .main) { notification in
          guard let audioRouteChangeReason = notification.userInfo?[AVAudioSessionRouteChangeReasonKey] as? UInt else {
              self.testFailed()
              return
          }

          switch audioRouteChangeReason {
          case AVAudioSession.RouteChangeReason.newDeviceAvailable.rawValue:
              headphonesState.onNext(.plugedIn)
          case AVAudioSession.RouteChangeReason.oldDeviceUnavailable.rawValue:
              headphonesState.onNext(.plugedOut)
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
    test.isPassed = true
      NotificationCenter.default.removeObserver(observer as Any)
      showNextTestViewController()
  }
}

//
//  BiometricsTestViewModel.swift
//  Forward Leasing
//
//  Created by Kirirushi on 20.12.2019.
//  Copyright © 2019 Arcsinus. All rights reserved.
//

import LocalAuthentication
import RxCocoa
import RxSwift

class BiometricsTestViewModel: BaseControllerViewModel {
  var test: Test
  var page: Int

  init(_ test: Test, page: Int) {
    self.test = test
    self.page = page
    super.init()
  }
  
  private let biometricsObservable = PublishSubject<Void>()
  
  func startTest() -> Observable<Void> {
    let myContext = LAContext()
    var authError: NSError?
    if myContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
      myContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: Constant.faceIdAutentificationString) { success, evaluateError in
        DispatchQueue.main.async {
          if success {
            self.biometricsObservable.onNext(())
            self.biometricsObservable.onCompleted()
          }
        }
      }
    } else {
      biometricsObservable.onCompleted()
    }
    return biometricsObservable
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

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
  
  func startTest(isSafeArea: Bool) -> Observable<Void> {
    let localizedReason = isSafeArea ? "Проверка работоспособности FaceID" : "Проверка работоспособности TouchID"
    let myContext = LAContext()
    var authError: NSError?
    if myContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
      myContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: localizedReason) { success, evaluateError in
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
    test.timeSpent = DiagnosticService.shared.calculateSpentTime()
    test.isPassed = true
    showNextTestViewController()
  }
}

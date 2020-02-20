//
//  CellNetworkTestViewModel.swift
//  Forward Leasing
//
//  Created by Kirirushi on 17.12.2019.
//  Copyright © 2019 Arcsinus. All rights reserved.
//

import CoreTelephony
import RxCocoa
import RxSwift
import UIKit

class CellNetworkTestViewModel: BaseControllerViewModel {
  var test: Test
  var page: Int

  init(_ test: Test, page: Int) {
    self.test = test
    self.page = page
    super.init()
  }
  
  let availabilitySIM = BehaviorSubject<Bool>(value: true)

  var notWorkingButtonPressed = PublishSubject<Void>()
  private let disposeBag = DisposeBag()

  override func setupModel() {
    super.setupModel()
    checkSIMCard()
    notWorkingButtonPressed.subscribe(onNext: { [unowned self] () in
      self.notWorkingDiagnostic()
    }).disposed(by: disposeBag)
  }
  
  func checkSIMCard() {
    let info = CTTelephonyNetworkInfo()
    let carrier = info.subscriberCellularProvider
    availabilitySIM.onNext(carrier?.mobileNetworkCode != nil)

    info.subscriberCellularProviderDidUpdateNotifier = { inCTCarrier in
        DispatchQueue.main.async(execute: {
          self.availabilitySIM.onNext(inCTCarrier.mobileNetworkCode != nil)
        })
    }

  }

  func testFailed() {
    test.isPassed = false
    abortDiagnostik()
  }

}

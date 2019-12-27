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
  private var obs: NSKeyValueObservation?

  override func setupModel() {
    super.setupModel()
    checkSIMCard()
  }
  
  func checkSIMCard() {
    let provider = CTTelephonyNetworkInfo().subscriberCellularProvider
    availabilitySIM.onNext(provider?.mobileNetworkCode != nil)
    
    obs = provider?.observe(\.mobileNetworkCode, options: .new, changeHandler: { (ctCarrier, value) in
      self.availabilitySIM.onNext(value.newValue != nil)
    })
  }

  func stopCheckingSIMCard() {
      obs?.invalidate()
  }

  func testFailed() {
    test.isPassed = false
    abortDiagnostik()
  }

}

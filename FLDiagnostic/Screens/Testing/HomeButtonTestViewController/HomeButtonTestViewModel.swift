//
//  HomeButtonTestViewModel.swift
//  Forward Leasing
//
//  Created by Kirirushi on 06.12.2019.
//  Copyright © 2019 Arcsinus. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class HomeButtonTestViewModel: BaseControllerViewModel {
  var test: Test
  var page: Int

  init(_ test: Test, page: Int) {
    self.test = test
    self.page = page
    super.init()
  }
  
  var completed: Bool = false
  var testSucceed = PublishSubject<Void>()
  var disposeBag = DisposeBag()

  override func setupModel() {
    super.setupModel()
    
    UIApplication.shared.rx.applicationDidEnterBackground.subscribe(onNext: { (state) in
      self.testSucceed.onNext(Void())
    }).disposed(by: disposeBag)
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

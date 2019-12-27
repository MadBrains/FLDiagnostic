//
//  AccelerometerTestViewModel.swift
//  Forward Leasing
//
//  Created by Kirirushi on 04.12.2019.
//  Copyright © 2019 Arcsinus. All rights reserved.
//

import CoreMotion
import RxCoreMotion
import RxSwift
import UIKit

class AxisCheck {
    var xCheck = false
    var yCheck = false
    var zCheck = false

    var testCompleted: Bool {
        return xCheck && yCheck && zCheck
    }
}

class AccelerometerTestViewModel: BaseControllerViewModel {
  var test: Test
  var page: Int

  init(_ test: Test, page: Int) {
    self.test = test
    self.page = page
    super.init()
  }
  var completed: Bool = false
  private let disposeBag = DisposeBag()

  private var xTest: (top: Bool, bottom: Bool) = (false, false)
  private var yTest: (top: Bool, bottom: Bool) = (false, false)
  private var zTest: (top: Bool, bottom: Bool) = (false, false)

    func startTest() -> Observable<AxisCheck> {
      return Observable.create({ [unowned self] (observer) -> Disposable in
        return CMMotionManager().rx.acceleration
//            .debug()
        .subscribe(onNext: { (acceleration) in
          let axisCheck = AxisCheck()

             self.xTest = (acceleration.x > 0.9 || self.xTest.top, acceleration.x < -0.9 || self.xTest.bottom)
             axisCheck.xCheck = self.xTest == (true, true)

             self.yTest = (acceleration.y > 0.9 || self.yTest.top, acceleration.y < -0.9 || self.yTest.bottom)
             axisCheck.yCheck = self.yTest == (true, true)

             self.zTest = (acceleration.z > 0.9 || self.zTest.top, acceleration.z < -0.9 || self.zTest.bottom)
             axisCheck.zCheck = self.zTest == (true, true)
          
            observer.onNext(axisCheck)
            if axisCheck.testCompleted {
              observer.onCompleted()
            }
        })
      })
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

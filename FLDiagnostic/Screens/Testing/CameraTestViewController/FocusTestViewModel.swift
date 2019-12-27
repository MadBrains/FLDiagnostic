//
//  FocusTestViewModel.swift
//  Forward Leasing
//
//  Created by Kirirushi on 13.12.2019.
//  Copyright © 2019 Arcsinus. All rights reserved.
//

import AVFoundation
import RxCocoa
import RxSwift
import UIKit

class FocusTestViewModel: BaseControllerViewModel {
  var test: Test
  var page: Int

  init(_ test: Test, page: Int) {
    self.test = test
    self.page = page
    super.init()
  }
  var qrCodeObservable = PublishSubject<Void>()

  func testFailed() {
    test.isPassed = false
    abortDiagnostik()
  }

  func startNextTest() {
    test.isPassed = true
    showNextTestViewController()
  }
}
extension FocusTestViewModel: AVCaptureMetadataOutputObjectsDelegate {
  func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
    if let metadataObject = metadataObjects.first {
      guard metadataObject is AVMetadataMachineReadableCodeObject else { return }
      qrCodeObservable.onNext(())
      qrCodeObservable.onCompleted()
    }
  }
}

//
//  NFCTestViewModel.swift
//  Forward Leasing
//
//  Created by Kirirushi on 25.12.2019.
//  Copyright © 2019 Arcsinus. All rights reserved.
//

import CoreNFC
import RxCocoa
import RxSwift

@available(iOS 11.0, *)
class NFCTestViewModel: BaseControllerViewModel {
  var test: Test
  var page: Int

  init(_ test: Test, page: Int) {
    self.test = test
    self.page = page
    super.init()
  }

  let nfcReaderObservable = PublishSubject<Void>()
  let disposeBag = DisposeBag()

  var session: NFCNDEFReaderSession?

  @available(iOS 11.0, *)
  func startTest() -> Observable<Void> {
    session = NFCNDEFReaderSession(delegate: self, queue: DispatchQueue.main, invalidateAfterFirstRead: true)
    session?.begin()
    return nfcReaderObservable
  }

  func testFailed() {
    print("NFC test failed!")
  }

  func startNextTest(isSafeArea: Bool = false) {
    showNextTestViewController()
  }
}
@available(iOS 11.0, *)
extension NFCTestViewModel: NFCNDEFReaderSessionDelegate {
  func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
    print(error.localizedDescription)
    testFailed()
  }

  func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
    nfcReaderObservable.onNext(())
  }
  func readerSessionDidBecomeActive(_ session: NFCNDEFReaderSession) {
  }
}

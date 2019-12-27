//
//  BluetoothTestViewModel.swift
//  Forward Leasing
//
//  Created by Kirirushi on 10.12.2019.
//  Copyright © 2019 Arcsinus. All rights reserved.
//

import CoreBluetooth
import RxCocoa
import RxSwift
import UIKit

class BluetoothTestViewModel: BaseControllerViewModel{
  var test: Test
  var page: Int

  init(_ test: Test, page: Int) {
    self.test = test
    self.page = page
    super.init()
  }
  
  enum State {
      case on
      case off
  }

  enum SearchState {
      case devicesFound
      case notFound
      case anotherState
  }

  private var manager: CBCentralManager?
  private var testFinished = false
  private var observableState = PublishSubject<State>()
  private var observableScan = PublishSubject<SearchState>()

  func canStartTest() -> Observable<State> {
      DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
          self.checkBluetooth()
      }
      return observableState
  }

  func checkBluetooth() {
      manager = CBCentralManager(delegate: self, queue: nil, options: nil)
  }

  func scanBluetooth() {
      manager?.scanForPeripherals(withServices: nil, options: nil)
  }

  func testFailed() {
    test.isPassed = false
    abortDiagnostik()
  }

  func startTest() -> Observable<SearchState> {
      DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
          self.scanBluetooth()
      }
      DispatchQueue.main.asyncAfter(deadline: .now() + 20) {
          self.observableScan.onNext(.notFound)
      }
      return observableScan.asObservable()
  }

  func startNextTest() {
      if !testFinished {
          testFinished = true
          test.isPassed = true
          showNextTestViewController()
      }
  }
}

extension BluetoothTestViewModel: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOff:
            observableState.onNext(.off)
        case .poweredOn:
            observableState.onNext(.on)
        default:
            observableState.onError(NSError(domain: "Invalid state of bluetooth", code: -1, userInfo: nil))
        }
    }
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        central.stopScan()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.observableScan.onNext(.devicesFound)
            self.observableScan.onCompleted()
        }
    }
}

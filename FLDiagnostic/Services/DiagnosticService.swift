//
//  DiagnosticService.swift
//  Forward Leasing
//
//  Created by Данил on 24/12/2019.
//  Copyright © 2019 Arcsinus. All rights reserved.
//

import UIKit
import Alamofire

class DiagnosticService {
  
  static let shared = DiagnosticService()
  
  var id: String?
  var imei: String = ""
  var tests: [Test] { return diagnostic?.device.model?.tests ?? [] }
  var questions: [Question] { return diagnostic?.device.model?.questions ?? [] }
  var allPages: Int { return tests.count + questions.count }
  var testDate = Date()
  var testControllers = [UIViewController]()
  var batteryLevelOnStart: Int = 0

  private var currentPage: Int = 0
  private var diagnostic: DiagnosticResponse?

  func setCurrentDiagnostikID(_ id: String, _ imei: String) {
    self.id = id
    self.imei = imei
  }
  
  func setCurrentDiagnostikSesion(_ diagnostic: DiagnosticResponse) {
    self.diagnostic = diagnostic
    currentPage = 0
    batteryLevelOnStart = DeviceService.batteryLevel
    testDate = Date()
    createControllersStack()
  }

  func getNextTestViewController() -> UIViewController? {
    if currentPage - 1 <= tests.count {
      let viewController = testControllers[currentPage]
      currentPage += 1
      return viewController
    }
    return nil
  }

  //swiftlint:disable cyclomatic_complexity


  private func createControllersStack() {
    var controllers = [UIViewController]()
    var page = 0

    for test in tests {
      page += 1
      print(page)
      print(test.code)
      switch test.code {
      case "bluetooth":
        let viewModel = BluetoothTestViewModel(test, page: page)
        guard let viewController = BluetoothTestViewController.create(viewModel) else { continue }
        controllers.append(viewController)
      case "face_id":
        let viewModel = BiometricsTestViewModel(test, page: page)
        guard let viewController = BiometricsTestViewController.create(viewModel) else { continue }
        controllers.append(viewController)
      case "fingerprint_scanner":
        let viewModel = BiometricsTestViewModel(test, page: page)
        guard let viewController = BiometricsTestViewController.create(viewModel) else { continue }
        controllers.append(viewController)
      case "accelerometer":
        let viewModel = AccelerometerTestViewModel(test, page: page)
        guard let viewController = AccelerometerTestViewController.create(viewModel) else { continue }
        controllers.append(viewController)
      case "vibration_module":
        let viewModel = VibrationTestViewModel(test, page: page)
        guard let viewController = VibrationTestViewController.create(viewModel) else { continue }
        controllers.append(viewController)
      case "loud_speaker":
        let viewModel = SoundTestViewModel(test, page: page)
        guard let viewController = SoundTestViewController.create(viewModel) else { continue }
        controllers.append(viewController)
      case "wifi":
        let viewModel = TestWifiViewModel(test, page: page)
        guard let viewController = TestWiFiViewController.create(viewModel) else { continue }
        controllers.append(viewController)
      case "home_button":
        let viewModel = HomeButtonTestViewModel(test, page: page)
        guard let viewController = HomeButtonTestViewController.create(viewModel) else { continue }
        controllers.append(viewController)
      case "volume_buttons":
        let viewModel = VolumeTestViewModel(test, page: page)
        guard let viewController = VolumeTestViewController.create(viewModel) else { continue }
        controllers.append(viewController)
      case "cellular_module":
        let viewModel = CellNetworkTestViewModel(test, page: page)
        guard let viewController = CellNetworkTestViewController.create(viewModel) else { continue }
        controllers.append(viewController)
      case "main_camera":
        let viewModel = MainCameraTestViewModel(test, page: page)
        guard let viewController = MainCameraTestViewController.create(viewModel) else { continue }
        controllers.append(viewController)
      case "front_camera":
        let viewModel = FrontCameraTestViewModel(test, page: page)
        guard let viewController = FrontCameraTestViewController.create(viewModel) else { continue }
        controllers.append(viewController)
      case "main_camera_focus":
        let viewModel = FocusTestViewModel(test, page: page)
        guard let viewController = FocusTestViewController.create(viewModel) else { continue }
        controllers.append(viewController)
      case "flashlight":
        let viewModel = FlashlightTestViewModel(test, page: page)
        guard let viewController = FlashlightTestViewController.create(viewModel) else { continue }
        controllers.append(viewController)
      case "display":
        let viewModel = ScreenTestViewModel(test, page: page)
        guard let viewController = ScreenTestViewController.create(viewModel) else { continue }
        controllers.append(viewController)
      case "charging":
        let viewModel = ChargerTestViewModel(test, page: page)
        guard let viewController = ChargerTestViewController.create(viewModel) else { continue }
        controllers.append(viewController)
      case "ring_silent_button":
        let viewModel = SilentModeTestViewModel(test, page: page)
        guard let viewController = SilentModeTestViewController.create(viewModel) else { continue }
        controllers.append(viewController)
      case "headphones_jack":
        let viewModel = HeadphonesTestViewModel(test, page: page)
        guard let viewController = HeadphonesTestViewController.create(viewModel) else { continue }
        controllers.append(viewController)
      case "touchscreen":
        let viewModel = TouchscreenTestViewModel(test, page: page)
        guard let viewController = TouchscreenTestViewController.create(viewModel) else { continue }
        controllers.append(viewController)
      case "moisture_under_the_screen":
        let viewModel = MoistureUnderGlassTestViewModel(test, page: page)
        guard let viewController = MoistureUnderGlassTestViewController.create(viewModel) else { continue }
        controllers.append(viewController)
      case "nfc":
        if #available(iOS 11.0, *) {
          let viewModel = NFCTestViewModel(test, page: page)
          guard let viewController = NFCTestViewController.create(viewModel) else { continue }
          controllers.append(viewController)
        }
      default:
        page -= 1
      }
    }

    for question in questions {
      page += 1
      if question.type == "general" {
        let viewModel = BinaryQuestionViewModel(question, page)
        guard let viewController = BinarQuestionViewController.create(viewModel) else { continue }
        controllers.append(viewController)
      } else if question.type == "number_from_interval" {
        let viewModel = TextQuestionViewModel(question, page)
        guard let viewController = TextQuestionViewController.create(viewModel) else { continue }
        controllers.append(viewController)
      }

    }

    self.testControllers = controllers
  }

  func createTestResultParameters() -> [Parameters] {
    var results = [Parameters]()

    for test in tests {
      let result: Parameters = ["testId": test.id, "isPassed": test.isPassed == nil ? NSNull() : test.isPassed, "timeSpent": 0]
      results.append(result)
    }
    return results
  }

  func createQuestionsResultParameters() -> [Parameters] {
    var results = [Parameters]()

    for question in questions {
      if question.type == "number_from_interval" {
        let result: Parameters = ["questionId": question.id, "answer": question.isPassed == nil ? NSNull() : question.isPassed]
        results.append(result)
      } else if question.type == "general" {
        let result: Parameters = ["questionId": question.id, "answer": question.answer == nil ? NSNull() : question.answer]
        results.append(result)
      }
    }
    return results
  }
  //front_camera
}

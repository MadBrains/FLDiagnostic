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
  typealias TestingEndedWithGrade = (_ grade: String?, _ error: String?) -> Void
  static let shared = DiagnosticService()
  
  var id: String?
  var imei: String = ""
  var serverUrl: String = ""
  var tests: [Test] { return diagnostic?.device.model?.tests ?? [] }
  var questions: [Question] { return diagnostic?.device.model?.questions ?? [] }
  var allPages: Int { return testControllers.count }
  var testEndDate = Date()
  var testDate = Date()
  var testControllers = [UIViewController]()
  var batteryLevelOnStart: Int = 0
  var questionsResetCount: Int = 0
  
  var onGetGrade: TestingEndedWithGrade?
  
  private var currentPage: Int = 0
  private var diagnostic: DiagnosticResponse?

  func setCurrentDiagnostikID(_ id: String, _ url: String) {
    self.id = id
    self.serverUrl = url
  }
  
  func setCurrentDiagnostikSesion(_ diagnostic: DiagnosticResponse) {
    self.diagnostic = diagnostic
    currentPage = 0
    batteryLevelOnStart = DeviceService.batteryLevel
    resetTimer()
    createControllersStack()
  }

  func resetTimer() {
    testEndDate = Date().addMinutes(minutes: 20)
    testDate = Date()
  }

  func getNextTestViewController() -> UIViewController? {
    if currentPage <= testControllers.count - 1 {
      let viewController = testControllers[currentPage]
      currentPage += 1
      return viewController
    }
    return nil
  }

  //swiftlint:disable cyclomatic_complexity

  private func createControllersStack() {
    var page = 0
    let model = DeviceColorViewModel()
    var controllers = [UIViewController]()
    if let controller = DeviceColorViewController.create(model) {
      controllers.append(controller)
    }

    for test in tests {
      page += 1
      print(page)
      print(test.code)
      switch test.code {
      case "bind_accounts":
        page -= 1
        test.isPassed = true
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
        page -= 1
        test.isPassed = true
//        if #available(iOS 11.0, *) {
//          let viewModel = NFCTestViewModel(test, page: page)
//          guard let viewController = NFCTestViewController.create(viewModel) else { continue }
//          controllers.append(viewController)
//        }
      default:
        page -= 1
      }
    }

    for question in questions {
      page += 1
      switch question.type {
      case "general":
        let viewModel = BinaryQuestionViewModel(question, page)
        guard let viewController = BinarQuestionViewController.create(viewModel) else { continue }
        controllers.append(viewController)
      case "number_from_interval":
        let viewModel = TextQuestionViewModel(question, page)
        guard let viewController = TextQuestionViewController.create(viewModel) else { continue }
        controllers.append(viewController)
      default:
        break
      }

    }
    let viewModel = ResetQuestionsViewModel(isResetting: false)
    if let viewController = ResetQuestionsViewController.create(viewModel) {
      controllers.append(viewController)
    }

    self.testControllers = controllers
  }

  func createTestResultParameters() -> [Parameters] {
    var results = [Parameters]()

    for test in tests {
      print(test.timeSpent)
      let result: Parameters = ["testId": test.id, "isPassed": test.isPassed == nil ? NSNull() : test.isPassed, "timeSpent": test.timeSpent == nil ? NSNull() : test.timeSpent]
      results.append(result)
    }
    return results
  }

  func createQuestionsResultParameters() -> [Parameters] {
    var results = [Parameters]()

    for question in questions {
      if question.type == "general" {
        let result: Parameters = ["questionId": question.id, "answer": question.isPassed == nil ? NSNull() : question.isPassed, "timeSpent": question.timeSpent == nil ? NSNull() : question.timeSpent]
        results.append(result)
      } else if question.type == "number_from_interval" {
        let result: Parameters = ["questionId": question.id, "answer": question.answer == nil ? NSNull() : question.answer, "timeSpent": question.timeSpent == nil ? NSNull() : question.timeSpent]
        results.append(result)
      }
    }
    return results
  }
  
  func calculateSpentTime() -> Int {
    let testTime = testDate
    testDate = Date()
    return Int(Date().timeIntervalSince(testTime))
  }
  //front_camera
}

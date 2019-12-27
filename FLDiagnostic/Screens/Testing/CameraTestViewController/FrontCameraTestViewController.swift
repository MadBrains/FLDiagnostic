//
//  FrontCameraTestViewController.swift
//  Forward Leasing
//
//  Created by Kirirushi on 13.12.2019.
//  Copyright © 2019 Arcsinus. All rights reserved.
//

import AVFoundation
import RxCocoa
import RxSwift
import UIKit

class FrontCameraTestViewController: BaseViewController {
  @IBOutlet private weak var yesButton: BorderedButton!
  @IBOutlet private weak var noButton: BorderedButton!
  @IBOutlet private weak var testLabel: UILabel!

  private var captureSession: AVCaptureSession!
  private var stillImageOutput: AVCapturePhotoOutput!
  private var videoPreviewLayer: AVCaptureVideoPreviewLayer?

  private var viewModel: FrontCameraTestViewModel!
  private let disposeBag = DisposeBag()

  override func viewDidLoad() {
    super.viewDidLoad()

    setupStyle()

    yesButton.rx.tap
      .subscribe(onNext: {
        self.endTest()
      })
      .disposed(by: disposeBag)

    noButton.rx.tap
      .subscribe(onNext: {
          self.viewModel.testFailed()
      })
      .disposed(by: disposeBag)

    testLabel.layer.zPosition = 100

    startFrontCameraSession()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    navigationController?.navigationBar.shadowImage = UIImage()
    navigationController?.navigationBar.isTranslucent = true
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)

    navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
    navigationController?.navigationBar.shadowImage = nil
}

  func startFrontCameraSession() {
    captureSession = AVCaptureSession()
    captureSession.beginConfiguration()
    captureSession.sessionPreset = .medium

    guard let frontCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else {
      viewModel.testFailed()
      return
    }
    do {
      let input = try AVCaptureDeviceInput(device: frontCamera)
      stillImageOutput = AVCapturePhotoOutput()

      if captureSession.canAddInput(input) && captureSession.canAddOutput(stillImageOutput) {
        captureSession.addInput(input)
        captureSession.addOutput(stillImageOutput)

        setupLivePreview()
      }
    } catch {
      viewModel.testFailed()
    }
  }

  func setupLivePreview() {
    videoPreviewLayer?.removeFromSuperlayer()
    videoPreviewLayer = nil
    videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)

    videoPreviewLayer?.videoGravity = .resizeAspectFill
    videoPreviewLayer?.connection?.videoOrientation = .portrait
    view.layer.addSublayer(videoPreviewLayer!)
    videoPreviewLayer?.zPosition = -1


    DispatchQueue.main.async {
      self.videoPreviewLayer!.frame.origin = .zero
      self.videoPreviewLayer!.frame.size = self.view.frame.size
      self.captureSession.commitConfiguration()
      self.captureSession.startRunning()
    }
  }

  func endTest() {
    DispatchQueue.main.async {
      self.videoPreviewLayer?.removeFromSuperlayer()
      self.captureSession.stopRunning()
    }
    
    viewModel.test.isPassed = false
    viewModel.showNextTestViewController()
  }

  private func setupStyle() {
    setDefaultNavigationBar(page: viewModel.page, infoHidden: viewModel.test.infoNeeded)
  }
}
extension FrontCameraTestViewController {
    static func create(_ viewModel: FrontCameraTestViewModel) -> FrontCameraTestViewController? {
        let storyboard = UIStoryboard(name: "Testing", bundle: Bundle(for: FLDiagnostic.self))
        let viewController = storyboard.instantiateViewController(withIdentifier: "FrontCameraTestViewController") as? FrontCameraTestViewController
        viewController?.viewModel = viewModel
        viewController?.setup(viewModel)
        return viewController
    }
}

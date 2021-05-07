//
//  FocusTestViewController.swift
//  Forward Leasing
//
//  Created by Kirirushi on 13.12.2019.
//  Copyright © 2019 Arcsinus. All rights reserved.
//

import AVFoundation
import RxCocoa
import RxSwift
import UIKit

class FocusTestViewController: BaseViewController {
  @IBOutlet private weak var testCompletedView: UIView!
  @IBOutlet private weak var testLabel: UILabel!
  @IBOutlet private weak var focusTestBackgroundView: UIView!
  @IBOutlet private weak var focusNotWorkingButton: BorderedButton!

  private var captureSession: AVCaptureSession!
  private var stillImageOutput: AVCapturePhotoOutput!
  private var videoPreviewLayer: AVCaptureVideoPreviewLayer?

  private var viewModel: FocusTestViewModel!
  private let disposeBag = DisposeBag()

  override func viewDidLoad() {
    super.viewDidLoad()

    setupStyle()

    focusNotWorkingButton.rx.tap
      .throttle(.milliseconds(1000), scheduler: MainScheduler.asyncInstance)
      .subscribe(onNext: { [unowned self] in
        self.viewModel.test.isPassed = false
        self.viewModel.notWorkingDiagnostic(self.viewModel.test)
      })
      .disposed(by: disposeBag)

    viewModel.qrCodeObservable
      .subscribe(onNext: {
        self.captureSession.stopRunning()
        self.endTest()
      })
      .disposed(by: disposeBag)

    testLabel.layer.zPosition = 100

    startFocusCameraSession()
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

  func startFocusCameraSession() {
    testLabel.text = "Сфокусируйте камеру на QR-коде"
    focusTestBackgroundView.isHidden = false

    startBackCameraSession()
    let metadataOutput = AVCaptureMetadataOutput()

    if (captureSession.canAddOutput(metadataOutput)) {
      captureSession.addOutput(metadataOutput)

      metadataOutput.setMetadataObjectsDelegate(viewModel, queue: DispatchQueue.main)
      metadataOutput.metadataObjectTypes = [.qr]
    }
  }

  func startBackCameraSession() {
    captureSession = AVCaptureSession()
    captureSession.beginConfiguration()
    captureSession.sessionPreset = .medium

    guard let backCamera = AVCaptureDevice.default(for: AVMediaType.video) else {
      viewModel.testFailed()
      return
    }
    do {
      let input = try AVCaptureDeviceInput(device: backCamera)
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
      self.focusNotWorkingButton.isHidden = true
      self.focusTestBackgroundView.isHidden = true
      self.testCompletedView.isHidden = false
      self.testLabel.isHidden = true
      self.videoPreviewLayer?.removeFromSuperlayer()
    }
    DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [viewModel] in
      viewModel?.startNextTest()
    }
  }

  private func setupStyle() {
    setDefaultNavigationBar(page: viewModel.page, info: viewModel.test.information)
  }
}
extension FocusTestViewController {
  static func create(_ viewModel: FocusTestViewModel) -> FocusTestViewController? {
    let storyboard = UIStoryboard(name: "Testing", bundle: Bundle(for: FLDiagnostic.self))
    let viewController = storyboard.instantiateViewController(withIdentifier: "FocusTestViewController") as? FocusTestViewController
    viewController?.viewModel = viewModel
    viewController?.setup(viewModel)
    return viewController
  }
}

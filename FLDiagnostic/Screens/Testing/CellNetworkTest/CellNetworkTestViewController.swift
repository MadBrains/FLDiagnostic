//
//  CellNetworkTestViewController.swift
//  Forward Leasing
//
//  Created by Kirirushi on 17.12.2019.
//  Copyright © 2019 Arcsinus. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class CellNetworkTestViewController: BaseViewController {
  @IBOutlet private weak var testCompletedView: UIView!

  @IBOutlet private weak var notWorkingButton: BorderedButton!

  @IBOutlet private weak var callTestView: UIView!
  @IBOutlet private weak var callButton: BorderedButton!

  @IBOutlet private weak var callQuestionTestView: UIView!
  @IBOutlet private weak var retryCallButton: UIButton!
  @IBOutlet private weak var noCallButton: BorderedButton!
  @IBOutlet private weak var hadCallButton: BorderedButton!

  @IBOutlet private weak var speakerQuestionTestView: UIView!
  @IBOutlet private weak var retryCallSoundButton: UIButton!
  @IBOutlet private weak var noSoundButton: BorderedButton!
  @IBOutlet private weak var wasSoundButton: BorderedButton!

  private var viewModel: CellNetworkTestViewModel!
  private let disposeBag = DisposeBag()

  var callDone = false

  override func viewDidLoad() {
    super.viewDidLoad()

    setupStyle()

    notWorkingButton.rx.tap.bind(to: viewModel.notWorkingButtonPressed).disposed(by: disposeBag)

    viewModel.availabilitySIM
      .subscribe(onNext: { isSimCardAvailable in
        if isSimCardAvailable {
          self.continueTest()
        } else {
          self.showSimErrorView()
        }
      })
      .disposed(by: disposeBag)

    callButton.rx.tap
      .subscribe(onNext: {
        let app = UIApplication.shared
        if let phoneCallURL = URL(string: "tel://060"), app.canOpenURL(phoneCallURL) {
          app.open(phoneCallURL, options: [:], completionHandler: { success in
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
              self.showCallTestQuestionView()
            }
          })
        }
      })
      .disposed(by: disposeBag)

    retryCallButton.rx.tap
      .subscribe(onNext: {
        let app = UIApplication.shared
        if let phoneCallURL = URL(string: "tel://060"), app.canOpenURL(phoneCallURL) {
          app.open(phoneCallURL, options: [:], completionHandler: { success in
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
              self.showCallTestQuestionView()
            }
          })
        }
      })
      .disposed(by: disposeBag)

    retryCallSoundButton.rx.tap
      .subscribe(onNext: {
        let app = UIApplication.shared
        if let phoneCallURL = URL(string: "tel://060"), app.canOpenURL(phoneCallURL) {
          app.open(phoneCallURL, options: [:], completionHandler: nil)
        }
      })
      .disposed(by: disposeBag)

    noSoundButton.rx.tap
      .subscribe(onNext: { [unowned self] in
        self.viewModel.test.isPassed = false
        self.viewModel.notWorkingDiagnostic(self.viewModel.test)
      })
      .disposed(by: disposeBag)

    noCallButton.rx.tap
      .subscribe(onNext: { [unowned self] in
        self.viewModel.test.isPassed = false
        self.viewModel.notWorkingDiagnostic(self.viewModel.test)
      })
      .disposed(by: disposeBag)

    hadCallButton.rx.tap
      .subscribe(onNext: {
        self.showCallSoundTestQuestionView()
      })
      .disposed(by: disposeBag)

    wasSoundButton.rx.tap
      .subscribe(onNext: {
        self.endTest()
      })
      .disposed(by: disposeBag)
  }
  
  func showSimErrorView() {
    callQuestionTestView.isHidden = true
    callTestView.isHidden = true
    speakerQuestionTestView.isHidden = true
  }
  func continueTest() {
    callTestView.isHidden = false
    callQuestionTestView.isHidden = true
    speakerQuestionTestView.isHidden = true
  }
  func showCallTestQuestionView() {
    callTestView.isHidden = true
    callQuestionTestView.isHidden = false
    speakerQuestionTestView.isHidden = true
  }
  func showCallSoundTestQuestionView() {
    callTestView.isHidden = true
    callQuestionTestView.isHidden = true
    speakerQuestionTestView.isHidden = false
  }

  func endTest() {
    DispatchQueue.main.async {
      self.showSimErrorView()
      self.testCompletedView.isHidden = false
    }
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [viewModel] in
      self.viewModel.test.timeSpent = DiagnosticService.shared.calculateSpentTime()
      self.viewModel.test.isPassed = true
        viewModel?.showNextTestViewController()
    }
  }

  private func setupStyle() {
    setDefaultNavigationBar(page: viewModel.page, info: viewModel.test.information)
  }
}
extension CellNetworkTestViewController {
  static func create(_ viewModel: CellNetworkTestViewModel) -> CellNetworkTestViewController? {
    let storyboard = UIStoryboard(name: "Testing", bundle: Bundle(for: FLDiagnostic.self))
    let viewController = storyboard.instantiateViewController(withIdentifier: "CellNetworkTestViewController") as? CellNetworkTestViewController
    viewController?.viewModel = viewModel
    viewController?.setup(viewModel)
    return viewController
  }
}

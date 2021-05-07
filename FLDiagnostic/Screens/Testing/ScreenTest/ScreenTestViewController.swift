//
//  ScreenTestViewController.swift
//  Forward Leasing
//
//  Created by Kirirushi on 11.12.2019.
//  Copyright © 2019 Arcsinus. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class ScreenTestViewController: BaseViewController {
  private var viewModel: ScreenTestViewModel!
  private let disposeBag = DisposeBag()

  @IBOutlet private weak var testCompletedView: UIView!

  @IBOutlet private weak var screenTestView: UIView!
  @IBOutlet private weak var startScreenTestButton: BorderedButton!
  @IBOutlet private weak var tutorialView: RoundedView!

  @IBOutlet private weak var testQuestionView: UIView!
  @IBOutlet private weak var retryScreenTestButton: UIButton!
  @IBOutlet private weak var noDefectsButton: BorderedButton!
  @IBOutlet private weak var haveDefectsButton: BorderedButton!

  private var hideStatusBar = false
  override var prefersStatusBarHidden: Bool {
    get {
      return hideStatusBar
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    setupStyle()

    startScreenTestButton.rx.tap
      .throttle(.milliseconds(1000), scheduler: MainScheduler.asyncInstance)
      .subscribe(onNext: {
        self.showScreenTestView()
      })
      .disposed(by: disposeBag)

    retryScreenTestButton.rx.tap
      .throttle(.milliseconds(1000), scheduler: MainScheduler.asyncInstance)
      .subscribe(onNext: {
        self.showScreenTestView()
      })
      .disposed(by: disposeBag)

    noDefectsButton.rx.tap
      .throttle(.milliseconds(1000), scheduler: MainScheduler.asyncInstance)
      .subscribe(onNext: {
        self.endTest()
      })
      .disposed(by: disposeBag)

    haveDefectsButton.rx.tap
      .throttle(.milliseconds(1000), scheduler: MainScheduler.asyncInstance)
      .subscribe(onNext: { [unowned self] in
        self.viewModel.test.isPassed = false
        self.viewModel.notWorkingDiagnostic(self.viewModel.test)
      })
      .disposed(by: disposeBag)
  }

  private func setupStyle() {
    setDefaultNavigationBar(page: viewModel.page, info: viewModel.test.information)
  }

  func showScreenTestView() {
    viewModel.resetColors()
    testQuestionView.isHidden = true
    navigationController?.setNavigationBarHidden(true, animated: false)
    hideStatusBar = true
    setNeedsStatusBarAppearanceUpdate()
    screenTestView.isHidden = false
    screenTestView.backgroundColor = viewModel.nextColor()

    let tapGesture = UITapGestureRecognizer()
    screenTestView.addGestureRecognizer(tapGesture)

    tapGesture.rx.event
      .bind(onNext: { recognizer in
        if let color = self.viewModel.nextColor() {
          self.screenTestView.backgroundColor = color
        } else {
          self.hideTutorialView()
          self.hideScreenTestView()
        }
      })
      .disposed(by: disposeBag)

    showTutorialView()
    DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
      self?.hideTutorialView()
    }
  }

  func hideScreenTestView() {
    screenTestView.isHidden = true
    testQuestionView.isHidden = false

    navigationController?.setNavigationBarHidden(false, animated: true)
    hideStatusBar = false
    setNeedsStatusBarAppearanceUpdate()
  }

  func showTutorialView() {
    tutorialView.isHidden = false
  }

  func hideTutorialView() {
    tutorialView.isHidden = true
  }

  func endTest() {
    self.viewModel.test.timeSpent = DiagnosticService.shared.calculateSpentTime()
    self.viewModel.test.isPassed = true
    viewModel?.showNextTestViewController()
  }
}
extension ScreenTestViewController {
  static func create(_ viewModel: ScreenTestViewModel) -> ScreenTestViewController? {
    let storyboard = UIStoryboard(name: "Testing", bundle: Bundle(for: FLDiagnostic.self))
    let viewController = storyboard.instantiateViewController(withIdentifier: "ScreenTestViewController") as? ScreenTestViewController
    viewController?.viewModel = viewModel
    viewController?.setup(viewModel)
    return viewController
  }
}

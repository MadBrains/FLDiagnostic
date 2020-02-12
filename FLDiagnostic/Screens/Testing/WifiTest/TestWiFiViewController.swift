//
//  TestWiFiViewController.swift
//  Forward Leasing
//
//  Created by Данил on 20/12/2019.
//  Copyright © 2019 Arcsinus. All rights reserved.
//

import RxSwift

class TestWiFiViewController: BaseViewController {
  @IBOutlet private weak var testTitleLabel: UILabel!
  @IBOutlet private weak var notWorkingButton: BorderedButton!
  @IBOutlet private weak var retryButton: BorderedButton!
  @IBOutlet private weak var infoImageView: UIImageView!
  @IBOutlet private weak var infoTitleLabel: UILabel!
  @IBOutlet private weak var loadingView: LoadingView!
  
  private var model: TestWifiViewModel!
  private var disposeBag = DisposeBag()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupRx()
    setupStyle()
  }
  
  private func setupRx() {
    notWorkingButton.rx.tap.bind(to: model.notWorkingButtonPressed).disposed(by: disposeBag)
    retryButton.rx.tap.bind(to: model.retryButtonPressed).disposed(by: disposeBag)
    
    model.retryHidden.bind(to: retryButton.rx.isHidden).disposed(by: disposeBag)
    model.notWorkingHidden.bind(to: notWorkingButton.rx.isHidden).disposed(by: disposeBag)
    
    model.infoImage.bind(to: infoImageView.rx.image).disposed(by: disposeBag)
    model.infoText.bind(to: infoTitleLabel.rx.text).disposed(by: disposeBag)
    model.infoTextColor.bind(to: infoTitleLabel.rx.textColor).disposed(by: disposeBag)
    model.titleText.bind(to: testTitleLabel.rx.text).disposed(by: disposeBag)
    model.isProgressing.bind(to: loadingView.rx.isAnimating).disposed(by: disposeBag)
  }
  
  private func setupStyle() {
    setDefaultNavigationBar(page: model.page, info: model.test.information)
  }
  
}

extension TestWiFiViewController {
  
  static func create(_ viewModel: TestWifiViewModel) -> TestWiFiViewController? {
    let storyboard = UIStoryboard(name: "Testing", bundle: Bundle(for: FLDiagnostic.self))
    let viewController = storyboard.instantiateViewController(withIdentifier: "TestWiFiViewController") as? TestWiFiViewController
    viewController?.model = viewModel
    viewController?.setup(viewModel)
    return viewController
  }
  
}

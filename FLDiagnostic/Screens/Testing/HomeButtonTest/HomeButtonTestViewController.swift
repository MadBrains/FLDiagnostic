//
//  HomeButtonTestViewController.swift
//  Forward Leasing
//
//  Created by Kirirushi on 06.12.2019.
//  Copyright © 2019 Arcsinus. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class HomeButtonTestViewController: BaseViewController {

  @IBOutlet private weak var notWorkingButton: BorderedButton!
  @IBOutlet private weak var testCompletedView: UIView!
  @IBOutlet private weak var tutorialView: RoundedView!

  @IBOutlet private weak var phoneArtImageView: UIImageView!

  private var viewModel: HomeButtonTestViewModel!
  private var disposeBag = DisposeBag()

  override func viewDidLoad() {
    super.viewDidLoad()

    setupStyle()

    phoneArtImageView.image = isSafeArea ? UIImage.FLImage("HomeButtonTestXArt") : UIImage.FLImage("HomeButtonTestArt")

    viewModel.testSucceed.asObserver().subscribe(onNext: { [unowned self] () in
      self.endTest()
    }).disposed(by: disposeBag)

    notWorkingButton.rx.tap
    .subscribe(onNext: { [unowned self] in
      self.viewModel.notWorkingDiagnostic(self.viewModel.test)
    })
    .disposed(by: disposeBag)

    DispatchQueue.main.asyncAfter(deadline: .now() + 4.5) {
      self.tutorialView.isHidden = true
    }
  }

  func endTest() {
    DispatchQueue.main.async {
      self.testCompletedView.isHidden = false
    }
    DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [viewModel] in
      viewModel?.startNextTest()
    }
  }

  private func setupStyle() {
    setDefaultNavigationBar(page: viewModel.page, info: viewModel.test.information)
  }
}
extension HomeButtonTestViewController {
  static func create(_ viewModel: HomeButtonTestViewModel) -> HomeButtonTestViewController? {
    let storyboard = UIStoryboard(name: "Testing", bundle: Bundle(for: FLDiagnostic.self))
    let viewController = storyboard.instantiateViewController(withIdentifier: "HomeButtonTestViewController") as? HomeButtonTestViewController
    viewController?.viewModel = viewModel
    viewController?.setup(viewModel)
    return viewController
  }
}

//
//  SilentModeTestViewController.swift
//  Forward Leasing
//
//  Created by Kirirushi on 25.12.2019.
//  Copyright © 2019 Arcsinus. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class SilentModeTestViewController: BaseViewController {
  @IBOutlet private weak var notWorkingButton: BorderedButton!
  @IBOutlet private weak var testCompletedView: UIView!

  @IBOutlet private weak var testLabel: UILabel!
  @IBOutlet private weak var testArt: UIImageView!

  private var viewModel: SilentModeTestViewModel!
  private var disposeBag = DisposeBag()

  override func viewDidLoad() {
    super.viewDidLoad()

    setupStyle()

    viewModel.startVolumeOffTest()
      .subscribe(onNext: {
        self.endTest()
      })
      .disposed(by: disposeBag)

    notWorkingButton.rx.tap
      .subscribe(onNext: { [unowned self] () in
        self.viewModel.notWorkingDiagnostic(self.viewModel.test)
      })
      .disposed(by: disposeBag)
  }

  private func setupStyle() {
    setDefaultNavigationBar(page: viewModel.page, info: viewModel.test.information)
  }

  func endTest() {
    DispatchQueue.main.async {
      self.testCompletedView.isHidden = false
    }
    DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [viewModel] in
      viewModel?.startNextTest()
    }
  }
}
extension SilentModeTestViewController {
  static func create(_ viewModel: SilentModeTestViewModel) -> SilentModeTestViewController? {
    let storyboard = UIStoryboard(name: "Testing", bundle: Bundle(for: FLDiagnostic.self))
    let viewController = storyboard.instantiateViewController(withIdentifier: "SilentModeTestViewController") as? SilentModeTestViewController
    viewController?.viewModel = viewModel
    viewController?.setup(viewModel)
    return viewController
  }
}

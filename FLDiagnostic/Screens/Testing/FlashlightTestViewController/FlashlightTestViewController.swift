//
//  FlashlightTestViewController.swift
//  Forward Leasing
//
//  Created by Kirirushi on 17.12.2019.
//  Copyright © 2019 Arcsinus. All rights reserved.
//

import UIKit
import RxSwift

class FlashlightTestViewController: BaseViewController {
    private var viewModel: FlashlightTestViewModel!
    private let disposeBag = DisposeBag()

    @IBOutlet private weak var noLightButton: BorderedButton!
    @IBOutlet private weak var haveLightButton: BorderedButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupStyle()

        noLightButton.rx.tap
            .subscribe(onNext: {
                self.viewModel.testFailed()
            })
            .disposed(by: disposeBag)

        haveLightButton.rx.tap
            .subscribe(onNext: {
                self.endTest()
            })
            .disposed(by: disposeBag)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        viewModel.toggleTorch(on: true)
    }

    func endTest() {
      viewModel.toggleTorch(on: false)
      if #available(iOS 11.0, *) {
          viewModel?.startNextTest(isSafeArea: self.view.safeAreaInsets.bottom > 0)
      } else {
          viewModel?.startNextTest()
      }
    }

    private func setupStyle() {
      setDefaultNavigationBar(page: viewModel.page, infoHidden: viewModel.test.infoNeeded)
    }
}
extension FlashlightTestViewController {
    static func create(_ viewModel: FlashlightTestViewModel) -> FlashlightTestViewController? {
        let storyboard = UIStoryboard(name: "Testing", bundle: Bundle(for: FLDiagnostic.self))
        let viewController = storyboard.instantiateViewController(withIdentifier: "FlashlightTestViewController") as? FlashlightTestViewController
        viewController?.viewModel = viewModel
        viewController?.setup(viewModel)
        return viewController
    }
}



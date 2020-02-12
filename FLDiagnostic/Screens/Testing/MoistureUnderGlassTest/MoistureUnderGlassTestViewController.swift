//
//  MoistureUnderGlassTestViewController.swift
//  Forward Leasing
//
//  Created by Kirirushi on 24.12.2019.
//  Copyright © 2019 Arcsinus. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class MoistureUnderGlassTestViewController: BaseViewController {
    private var viewModel: MoistureUnderGlassTestViewModel!
    private let disposeBag = DisposeBag()

    @IBOutlet private weak var yesButton: BorderedButton!
    @IBOutlet private weak var noButton: BorderedButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupStyle()

        yesButton.rx.tap
            .subscribe(onNext: {
              self.viewModel.test.isPassed = false
                self.viewModel.notWorkingDiagnostic()
            })
            .disposed(by: disposeBag)

        noButton.rx.tap
            .subscribe(onNext: {
                self.endTest()
            })
            .disposed(by: disposeBag)
    }

    func endTest() {
      viewModel?.startNextTest()
    }

    private func setupStyle() {
      setDefaultNavigationBar(page: viewModel.page, info: viewModel.test.information)
    }
}
extension MoistureUnderGlassTestViewController {
    static func create(_ viewModel: MoistureUnderGlassTestViewModel) -> MoistureUnderGlassTestViewController? {
        let storyboard = UIStoryboard(name: "Testing", bundle: Bundle(for: FLDiagnostic.self))
        let viewController = storyboard.instantiateViewController(withIdentifier: "MoistureUnderGlassTestViewController") as? MoistureUnderGlassTestViewController
        viewController?.viewModel = viewModel
        viewController?.setup(viewModel)
        return viewController
    }
}
